import 'part_downloader.dart';

/// One running or resumable background download.
abstract class EngineTransfer {
  /// Completes when the task reaches a final state. Read it after
  /// [resume], which starts a new wait.
  Future<PartResult> get result;

  /// Calls [onProgress] with 0..1; returns a function that stops listening.
  void Function() listenProgress(void Function(double fraction) onProgress);

  Future<bool> pause();
  Future<bool> resume();
  Future<void> cancel();
}
