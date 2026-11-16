import 'package:background_downloader/background_downloader.dart';

import 'engine_transfer.dart';
import 'part_downloader.dart';

/// [EngineTransfer] over a background_downloader [Transfer].
class PluginEngineTransfer implements EngineTransfer {
  PluginEngineTransfer(this._transfer);
  final Transfer _transfer;

  @override
  Future<PartResult> get result async => switch ((await _transfer.result).status) {
        TaskStatus.complete => PartResult.complete,
        TaskStatus.canceled => PartResult.canceled,
        _ => PartResult.failed,
      };

  @override
  void Function() listenProgress(void Function(double fraction) onProgress) {
    final notifier = _transfer.progressNotifier;
    void onTick() {
      final p = notifier.value;
      if (p != null && p >= 0) onProgress(p);
    }

    notifier.addListener(onTick);
    return () => notifier.removeListener(onTick);
  }

  @override
  Future<bool> pause() => _transfer.pause();

  /// Uses the plugin's resume data when it has some; otherwise re-enqueues
  /// the same task, i.e. the original URL.
  @override
  Future<bool> resume() => _transfer.resume();

  @override
  Future<void> cancel() async {
    await _transfer.cancel();
  }
}
