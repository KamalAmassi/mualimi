/// Thresholds and caps. Tune here, never inline.
abstract final class Limits {
  // Tutor pipeline
  static const double bankMatchThreshold = 0.6;
  static const int maxPassages = 4;
  static const double passageScoreThreshold = 0.3;
  static const int dailyQuestionLimit = 30;
  static const int maxOutputTokens = 600;
  static const int maxLessonChars = 6000;
  static const double generationTemperature = 0.3;
  static const int maxPendingAttempts = 3;

  /// |bm25| at or above this counts as a full keyword match (score 1.0).
  static const double bm25Saturation = 10;
  static const int streamFlushMs = 50;

  // Downloads
  static const int downloadMarginBytes = 100 * 1024 * 1024;
  static const int maxUrlAttemptsPerPart = 3;
  static const int maxPartRedownloads = 3;
  static const int copyBufferBytes = 4 * 1024 * 1024;

  // Misc
  static const int nameMaxLength = 30;
  static const int historyMax = 200;
}
