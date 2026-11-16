/// Connection settings for the cloud tutor.
abstract final class TutorConfig {
  /// Passed at run time with `--dart-define=GEMINI_API_KEY=...`; empty means
  /// the cloud tutor is not configured.
  static const apiKey = String.fromEnvironment('GEMINI_API_KEY');

  static const model = 'gemini-3.5-flash-lite';
  static const baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const requestTimeoutSeconds = 30;

  static bool get isConfigured => apiKey.isNotEmpty;
}
