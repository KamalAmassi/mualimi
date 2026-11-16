import 'dart:async';
import 'dart:io';

import 'package:mualimi/features/content_manager/data/datasources/download_engine.dart';
import 'package:mualimi/features/content_manager/data/datasources/engine_task_info.dart';
import 'package:mualimi/features/content_manager/data/datasources/engine_transfer.dart';
import 'package:mualimi/features/content_manager/data/datasources/part_downloader.dart';

/// A transfer that ends when [finish] is called.
class FakeEngineTransfer implements EngineTransfer {
  var _done = Completer<PartResult>();
  int resumeCalls = 0;

  /// True while a downloader is listening, i.e. waiting on [result].
  bool listening = false;

  void finish(PartResult r) => _done.complete(r);

  @override
  Future<PartResult> get result => _done.future;

  @override
  void Function() listenProgress(void Function(double fraction) onProgress) {
    listening = true;
    return () => listening = false;
  }

  @override
  Future<bool> pause() async => true;

  @override
  Future<bool> resume() async {
    resumeCalls++;
    if (_done.isCompleted) _done = Completer<PartResult>();
    return true;
  }

  @override
  Future<void> cancel() async {}
}

/// In-memory stand-in for the plugin's task database. Keep one instance
/// across two [BackgroundPartDownloader]s to simulate an app restart.
class FakeDownloadEngine implements DownloadEngine {
  final known = <String, EngineTaskInfo>{};
  final transfers = <String, FakeEngineTransfer>{};
  final resumable = <String>{};
  final started = <String>[];
  final attached = <String>[];
  final forgotten = <String>[];

  /// Whether [dest] existed when each task was started.
  final destExistedAtStart = <bool>[];

  @override
  Future<void> init() async {}

  @override
  Future<EngineTaskInfo?> lookup(String taskId) async => known[taskId];

  @override
  Future<bool> hasResumeData(String taskId) async => resumable.contains(taskId);

  @override
  Future<EngineTransfer> attach(String taskId) async {
    attached.add(taskId);
    return transfers[taskId] ??= FakeEngineTransfer();
  }

  @override
  Future<EngineTransfer> start({
    required String taskId,
    required String url,
    required File dest,
  }) async {
    started.add(taskId);
    destExistedAtStart.add(dest.existsSync());
    known[taskId] = EngineTaskInfo(url: url, status: EngineTaskStatus.active, alive: true);
    return transfers[taskId] = FakeEngineTransfer();
  }

  @override
  Future<void> forget(String taskId) async {
    forgotten.add(taskId);
    known.remove(taskId);
    transfers.remove(taskId);
  }
}
