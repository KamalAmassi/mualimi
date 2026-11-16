/// Remembers which background task id each artifact part last used, so a
/// restarted app resumes that task instead of starting from zero.
abstract class DownloadTaskStore {
  /// Part index -> task id, only for parts that have one.
  Future<Map<int, String>> taskIds(String artifact);

  Future<void> saveTaskId(String artifact, int partIndex, String taskId);

  Future<void> removePart(String artifact, int partIndex);
}
