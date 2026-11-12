/// Thresholds and caps. Tune here, never inline.
abstract final class Limits {
  // Tutor pipeline
  static const int retrievalMinChunks = 3;
  static const int retrievalMaxChunks = 4;
  static const double outOfScopeThreshold = 0.35;
  static const int maxTokens = 512;
  static const int streamFlushMs = 50;
  static const double ftsWeight = 0.4;
  static const double vectorWeight = 0.6;

  // Device capability
  static const int minRamBytesForModel = 4 * 1024 * 1024 * 1024;

  // Downloads
  static const int downloadMarginBytes = 100 * 1024 * 1024;
  static const int maxUrlAttemptsPerPart = 3;
  static const int maxPartRedownloads = 3;
  static const int hashChunkBytes = 1024 * 1024;
  static const int copyBufferBytes = 4 * 1024 * 1024;

  // Misc
  static const int nameMaxLength = 30;
  static const int historyMax = 200;
}
