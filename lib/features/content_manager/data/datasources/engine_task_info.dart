enum EngineTaskStatus { active, paused, failed, complete, canceled }

/// What the download engine remembers about a task id from this run or an
/// earlier one.
class EngineTaskInfo {
  const EngineTaskInfo({required this.url, required this.status, required this.alive});

  /// The original URL the task was created with (never a redirect target).
  final String url;
  final EngineTaskStatus status;

  /// True when the OS still holds the task (running, enqueued, paused or
  /// waiting to retry); false for a task killed with the app.
  final bool alive;
}
