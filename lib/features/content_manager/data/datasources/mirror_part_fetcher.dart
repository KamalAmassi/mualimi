import 'dart:io';

import '../../../../core/constants/limits.dart';
import '../../domain/entities/artifact_info.dart';
import '../../domain/entities/artifact_part.dart';
import 'download_task_store.dart';
import 'memory_download_task_store.dart';
import 'part_downloader.dart';
import 'part_task_id.dart';

/// Fetches one part across its mirrors. Each mirror has its own
/// deterministic task id, persisted in [DownloadTaskStore], so after a cut
/// or a restart the same task is resumed; a failed task is resumed before
/// moving on to the next mirror.
class MirrorPartFetcher {
  MirrorPartFetcher(this._parts, [DownloadTaskStore? store])
      : _store = store ?? MemoryDownloadTaskStore();

  final PartDownloader _parts;
  final DownloadTaskStore _store;

  /// Forgets tasks saved for another version (or a part that no longer
  /// exists) of this artifact.
  Future<void> dropStale(ArtifactInfo a) async {
    final saved = await _store.taskIds(a.id);
    for (final MapEntry(key: partIndex, value: taskId) in saved.entries) {
      final current = a.parts.any((p) => p.index == partIndex) &&
          PartTaskId.isFor(taskId, a, partIndex);
      if (current) continue;
      await _parts.forget(taskId);
      await _store.removePart(a.id, partIndex);
    }
  }

  /// Tries the mirrors in order, starting from the one the last run used.
  Future<PartResult> fetch(
    ArtifactInfo a,
    ArtifactPart part,
    File file,
    void Function(double fraction) onProgress,
  ) async {
    final n = part.urls.length;
    final first = await _savedMirror(a, part);
    for (var i = 0; i < Limits.maxUrlAttemptsPerPart * n; i++) {
      final mirror = (first + i) % n;
      final taskId = PartTaskId.of(a, part.index, mirror);
      await _store.saveTaskId(a.id, part.index, taskId);
      Future<PartResult> attempt() => _parts.download(
          taskId: taskId, url: part.urls[mirror], dest: file, onProgress: onProgress);
      var result = await attempt();
      if (result == PartResult.failed && await _parts.canResume(taskId)) {
        result = await attempt();
      }
      if (result != PartResult.failed) return result;
    }
    return PartResult.failed;
  }

  /// Drops every mirror's task for [part] (after a checksum mismatch), so
  /// the next fetch starts from zero.
  Future<void> discard(ArtifactInfo a, ArtifactPart part) async {
    for (var m = 0; m < part.urls.length; m++) {
      await _parts.forget(PartTaskId.of(a, part.index, m));
    }
  }

  Future<int> _savedMirror(ArtifactInfo a, ArtifactPart part) async {
    final saved = (await _store.taskIds(a.id))[part.index];
    if (saved == null || !PartTaskId.isFor(saved, a, part.index)) return 0;
    final m = PartTaskId.mirrorOf(saved)!;
    return m < part.urls.length ? m : 0;
  }
}
