import 'dart:io';

import 'engine_task_info.dart';
import 'engine_transfer.dart';

/// The few background-download plugin calls [BackgroundPartDownloader]
/// needs, behind an interface so the resume/adopt rules can be tested.
abstract class DownloadEngine {
  /// Idempotent. Starts tracking tasks across restarts.
  Future<void> init();

  /// The tracked task with this id, or null if none is known.
  Future<EngineTaskInfo?> lookup(String taskId);

  /// True when the engine holds resume data for this task.
  Future<bool> hasResumeData(String taskId);

  /// A handle on the known task [taskId] (see [lookup]); does not enqueue.
  Future<EngineTransfer> attach(String taskId);

  /// Enqueues a new task downloading [url] to [dest].
  Future<EngineTransfer> start({required String taskId, required String url, required File dest});

  /// Cancels the task if alive and drops its tracking record.
  Future<void> forget(String taskId);
}
