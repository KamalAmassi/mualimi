/// Timing limits for fetching the remote manifest (content_manager only).
abstract final class ManifestTiming {
  /// Upper bound for the whole fetch: connecting, sending the request and
  /// reading the full body. The manifest is a small JSON document, so a
  /// response that has not fully arrived by then is treated as a network
  /// failure (and the cached manifest is used instead).
  static const Duration overallTimeout = Duration(seconds: 30);
}
