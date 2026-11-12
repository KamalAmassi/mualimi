import 'dart:io';

import 'package:background_downloader/background_downloader.dart';

import 'part_downloader.dart';

/// background_downloader implementation. Pause/resume is handled by the
/// plugin (HTTP Range); it re-requests the task's original URL, and we never
/// persist a post-redirect URL.
class BackgroundPartDownloader implements PartDownloader {
  Transfer? _transfer;
  bool _started = false;

  @override
  Future<PartResult> download({
    required String url,
    required File dest,
    required void Function(double fraction) onProgress,
  }) async {
    if (!_started) {
      await FileDownloader().start(autoCleanDatabase: true);
      _started = true;
    }
    await dest.parent.create(recursive: true);
    if (await dest.exists()) await dest.delete();

    final (baseDirectory, directory, filename) = await Task.split(file: dest);
    final task = DownloadTask(
      url: url,
      filename: filename,
      directory: directory,
      baseDirectory: baseDirectory,
      updates: Updates.statusAndProgress,
      allowPause: true,
      retries: 2,
      transferHints: {TransferHint.largeFile},
    );

    final transfer = await FileDownloader().transfers.start(task);
    _transfer = transfer;
    void onTick() {
      final p = transfer.progressNotifier.value;
      if (p != null && p >= 0) onProgress(p);
    }

    transfer.progressNotifier.addListener(onTick);
    try {
      final result = await transfer.result;
      return switch (result.status) {
        TaskStatus.complete => PartResult.complete,
        TaskStatus.canceled => PartResult.canceled,
        _ => PartResult.failed,
      };
    } finally {
      transfer.progressNotifier.removeListener(onTick);
      _transfer = null;
    }
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
