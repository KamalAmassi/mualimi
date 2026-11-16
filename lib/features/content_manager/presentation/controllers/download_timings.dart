/// Timing constants of the download flow.
abstract final class DownloadTimings {
  /// How long the network must stay up before a network pause resumes, so a
  /// flapping link triggers one resume, not many.
  static const networkDebounce = Duration(milliseconds: 1500);
}
