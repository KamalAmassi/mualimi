import 'dart:io';

enum PartResult { complete, failed, canceled }

/// Downloads one URL to one file with resume support. Kept behind an
/// interface so the retry/verify logic can be tested without a network.
abstract class PartDownloader {
  /// [onProgress] receives 0..1 for this file.
  Future<PartResult> download({
    required String url,
    required File dest,
    required void Function(double fraction) onProgress,
  });

  /// False when nothing is running or the server can't resume.
  Future<bool> pause();
  Future<bool> resume();
  Future<void> cancel();
}
