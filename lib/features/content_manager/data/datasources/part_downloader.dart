import 'dart:io';

enum PartResult { complete, failed, canceled }

/// Downloads one URL to one file with resume support. Kept behind an
/// interface so the retry/verify logic can be tested without a network.
abstract class PartDownloader {
  /// [taskId] is deterministic (see PartTaskId): calling again with the same
  /// id adopts or resumes the earlier task instead of starting over.
  /// [onProgress] receives 0..1 for this file.
  Future<PartResult> download({
    required String taskId,
    required String url,
    required File dest,
    required void Function(double fraction) onProgress,
  });

  /// True when [taskId] has resume data, so retrying it continues from
  /// where it stopped.
  Future<bool> canResume(String taskId);

  /// Drops any task and resume data for [taskId]; the next download of it
  /// starts from zero.
  Future<void> forget(String taskId);

  /// False when nothing is running or the server can't resume.
  Future<bool> pause();
  Future<bool> resume();
  Future<void> cancel();
}
