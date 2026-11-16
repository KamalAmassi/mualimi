abstract class AnswerNotificationRepository {
  Future<void> notifyAnswerReady(
      {required String question, required int historyId});

  /// Asks the system for permission to show notifications.
  Future<void> requestPermission();

  /// History ids of answers whose notification the student tapped.
  Stream<int> get taps;
}
