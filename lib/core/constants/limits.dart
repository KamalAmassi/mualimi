/// Thresholds and caps. Tune here, never inline.
abstract final class Limits {
  // Tutor pipeline
  static const int retrievalMinChunks = 3;
  static const int retrievalMaxChunks = 4;
  static const double outOfScopeThreshold = 0.35;
  /// Cap on the generated reply (session `maxOutputTokens`). Saves battery.
  static const int maxOutputTokens = 512;

  /// Model context window (flutter_gemma `maxTokens`): prompt + reply.
  static const int contextTokens = 2048;
  static const int generationTopK = 40;
  static const double generationTemperature = 0.4;

  /// |bm25| at or above this counts as a full keyword match (score 1.0).
  static const double bm25Saturation = 10;
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
