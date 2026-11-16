abstract class TutorUsageRepository {
  /// True once today's questions to the cloud tutor reach the daily limit.
  Future<bool> isDailyLimitReached();

  Future<void> recordQuestion();
}
