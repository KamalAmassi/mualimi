import 'dart:io';

import 'package:background_downloader/background_downloader.dart';

import 'download_engine.dart';
import 'engine_task_info.dart';
import 'engine_transfer.dart';
import 'plugin_engine_transfer.dart';

/// [DownloadEngine] backed by background_downloader.
///
/// Killed tasks are NOT rescheduled by the plugin
/// (`doRescheduleKilledTasks: false`): [BackgroundPartDownloader] finds them
/// by their deterministic id and resumes them itself, so a rescheduled copy
/// can never race a new task for the same file.
class PluginDownloadEngine implements DownloadEngine {
  FileDownloader get _fd => FileDownloader();
  Future<void>? _init;

  @override
  Future<void> init() => _init ??= _fd.start(doRescheduleKilledTasks: false, autoCleanDatabase: true);

  @override
  Future<EngineTaskInfo?> lookup(String taskId) async {
    final record = await _fd.database.recordForId(taskId);
    if (record == null) return null;
    return EngineTaskInfo(
      url: record.task.url,
      status: _statusOf(record.status),
      alive: await _fd.taskForId(taskId) != null,
    );
  }

  @override
  Future<bool> hasResumeData(String taskId) async {
    final record = await _fd.database.recordForId(taskId);
    if (record == null) return false;
    // taskCanResume can wait on a live server probe; never block on it.
    return _fd
        .taskCanResume(record.task)
        .timeout(const Duration(seconds: 5), onTimeout: () => false);
  }

  @override
  Future<EngineTransfer> attach(String taskId) async {
    final existing = _fd.transfers.forId(taskId);
    if (existing != null) return PluginEngineTransfer(existing);
    final record = await _fd.database.recordForId(taskId);
    if (record == null) throw StateError('no task $taskId to attach to');
    return PluginEngineTransfer(
      await _fd.transfers.getOrStart(record.task, reEnqueueIfFailed: false),
    );
  }

  @override
  Future<EngineTransfer> start({
    required String taskId,
    required String url,
    required File dest,
  }) async {
    final (baseDirectory, directory, filename) = await Task.split(file: dest);
    final task = DownloadTask(
      taskId: taskId,
      url: url,
      filename: filename,
      directory: directory,
      baseDirectory: baseDirectory,
      updates: Updates.statusAndProgress,
      allowPause: true,
      retries: 2,
      transferHints: {TransferHint.largeFile},
    );
    return PluginEngineTransfer(await _fd.transfers.start(task));
  }

  @override
  Future<void> forget(String taskId) async {
    if (await _fd.taskForId(taskId) != null) await _fd.cancelTaskWithId(taskId);
    await _fd.database.deleteRecordWithId(taskId);
    _fd.transfers.remove(taskId);
  }

  static EngineTaskStatus _statusOf(TaskStatus s) => switch (s) {
        TaskStatus.complete => EngineTaskStatus.complete,
        TaskStatus.canceled => EngineTaskStatus.canceled,
        TaskStatus.paused => EngineTaskStatus.paused,
        TaskStatus.failed || TaskStatus.notFound => EngineTaskStatus.failed,
        _ => EngineTaskStatus.active,
      };
}
