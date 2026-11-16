import 'dart:io';

import 'download_engine.dart';
import 'engine_task_info.dart';
import 'engine_transfer.dart';
import 'part_downloader.dart';
import 'plugin_download_engine.dart';

/// background_downloader implementation. Each part/mirror has a
/// deterministic task id, so a task from an earlier run is adopted or
/// resumed (HTTP Range) instead of restarted. Resume always re-requests the
/// task's original URL; a post-redirect URL is never persisted.
///
/// The destination is never deleted here: the plugin writes to a temp file
/// and only moves it to [dest] on completion.
class BackgroundPartDownloader implements PartDownloader {
  BackgroundPartDownloader({DownloadEngine? engine}) : _engine = engine ?? PluginDownloadEngine();

  final DownloadEngine _engine;
  EngineTransfer? _transfer;

  @override
  Future<PartResult> download({
    required String taskId,
    required String url,
    required File dest,
    required void Function(double fraction) onProgress,
  }) async {
    await _engine.init();
    await dest.parent.create(recursive: true);
    final transfer = await _obtain(taskId, url, dest);
    _transfer = transfer;
    final stopListening = transfer.listenProgress(onProgress);
    try {
      return await transfer.result;
    } finally {
      stopListening();
      _transfer = null;
    }
  }

  /// Adopts a live task, resumes a known one, or starts fresh: never two
  /// tasks for one destination.
  Future<EngineTransfer> _obtain(String taskId, String url, File dest) async {
    final known = await _engine.lookup(taskId);
    final restart = known == null ||
        known.url != url ||
        known.status == EngineTaskStatus.complete ||
        known.status == EngineTaskStatus.canceled;
    if (restart) {
      if (known != null) await _engine.forget(taskId);
      return _engine.start(taskId: taskId, url: url, dest: dest);
    }
    final transfer = await _engine.attach(taskId);
    final adoptAsIs = known.alive && known.status == EngineTaskStatus.active;
    if (!adoptAsIs) await transfer.resume();
    return transfer;
  }

  @override
  Future<bool> canResume(String taskId) async {
    await _engine.init();
    return _engine.hasResumeData(taskId);
  }

  @override
  Future<void> forget(String taskId) async {
    await _engine.init();
    await _engine.forget(taskId);
  }

  @override
  Future<bool> pause() async => await _transfer?.pause() ?? false;

  @override
  Future<bool> resume() async => await _transfer?.resume() ?? false;

  @override
  Future<void> cancel() async {
    await _transfer?.cancel();
  }
}
