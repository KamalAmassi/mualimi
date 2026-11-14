abstract class TutorConnectionRepository {
  bool get isOnline;

  /// False when the app was started without an API key.
  bool get isConfigured;

  /// Emits true each time the device goes from offline to online.
  Stream<bool> get onlineChanges;
}
