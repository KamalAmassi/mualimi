import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/content_manager/data/datasources/memory_download_task_store.dart';
import 'package:mualimi/features/content_manager/data/datasources/mirror_part_fetcher.dart';
import 'package:mualimi/features/content_manager/data/datasources/part_downloader.dart';
import 'package:mualimi/features/content_manager/domain/entities/artifact_info.dart';
import 'package:mualimi/features/content_manager/domain/entities/artifact_part.dart';

/// Answers each task id from a script of results (default: complete).
class _ScriptedParts implements PartDownloader {
  final script = <String, List<PartResult>>{};
  final resumable = <String>{};
  final calls = <String>[];
  final forgotten = <String>[];

  @override
  Future<PartResult> download({
    required String taskId,
    required String url,
    required File dest,
    required void Function(double fraction) onProgress,
  }) async {
    calls.add(taskId);
    final queue = script[taskId];
    return (queue == null || queue.isEmpty) ? PartResult.complete : queue.removeAt(0);
  }

  @override
  Future<bool> canResume(String taskId) async => resumable.contains(taskId);
  @override
  Future<void> forget(String taskId) async => forgotten.add(taskId);
  @override
  Future<bool> pause() async => false;
  @override
  Future<bool> resume() async => false;
  @override
  Future<void> cancel() async {}
}

void main() {
  const part = ArtifactPart(index: 0, urls: ['https://a/0', 'https://b/0'], size: 1, sha256: 'x');
  ArtifactInfo artifact(int version) => ArtifactInfo(
      id: 'pack', version: version, fileName: 'p.zip', totalSize: 1, sha256: 'x', parts: const [part]);
  final file = File('unused');
  late _ScriptedParts parts;
  late MemoryDownloadTaskStore store;

  setUp(() {
    parts = _ScriptedParts();
    store = MemoryDownloadTaskStore();
  });

  Future<PartResult> fetch(ArtifactInfo a) =>
      MirrorPartFetcher(parts, store).fetch(a, part, file, (_) {});

  test('same artifact/version/part keeps its task id across a restart', () async {
    parts.script['pack-v3-p0-m0'] = [PartResult.canceled]; // the app went away
    await fetch(artifact(3));
    await fetch(artifact(3)); // new fetcher, same persisted store
    expect(parts.calls, ['pack-v3-p0-m0', 'pack-v3-p0-m0']);
  });

  test('a restart continues on the mirror the last run was using', () async {
    parts.script['pack-v3-p0-m0'] = [PartResult.failed];
    parts.script['pack-v3-p0-m1'] = [PartResult.canceled];
    await fetch(artifact(3));
    parts.calls.clear();
    await fetch(artifact(3));
    expect(parts.calls, ['pack-v3-p0-m1']);
    expect((await store.taskIds('pack'))[0], 'pack-v3-p0-m1');
  });

  test('a failed task with resume data is resumed before switching mirror', () async {
    parts.script['pack-v3-p0-m0'] = [PartResult.failed, PartResult.failed];
    parts.resumable.add('pack-v3-p0-m0');
    final result = await fetch(artifact(3));
    expect(result, PartResult.complete);
    expect(parts.calls, ['pack-v3-p0-m0', 'pack-v3-p0-m0', 'pack-v3-p0-m1']);
  });

  test('a failed task without resume data moves straight to the next mirror', () async {
    parts.script['pack-v3-p0-m0'] = [PartResult.failed];
    await fetch(artifact(3));
    expect(parts.calls, ['pack-v3-p0-m0', 'pack-v3-p0-m1']);
  });

  test('stale task ids from another version are forgotten and removed', () async {
    await store.saveTaskId('pack', 0, 'pack-v2-p0-m1');
    await store.saveTaskId('pack', 5, 'pack-v3-p5-m0'); // part no longer exists
    await MirrorPartFetcher(parts, store).dropStale(artifact(3));
    expect(parts.forgotten, ['pack-v2-p0-m1', 'pack-v3-p5-m0']);
    expect(await store.taskIds('pack'), isEmpty);
  });

  test('discard forgets every mirror task of the part', () async {
    await MirrorPartFetcher(parts, store).discard(artifact(3), part);
    expect(parts.forgotten, ['pack-v3-p0-m0', 'pack-v3-p0-m1']);
  });
}
