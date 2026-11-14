abstract class LocalNotificationDataSource {
  Future<void> show(
      {required int id,
      required String title,
      required String body,
      String? payload});

  Future<void> requestPermission();

  /// Payloads of notifications the student tapped.
  Stream<String> get taps;
}
