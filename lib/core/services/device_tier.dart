enum DeviceTier {
  /// Enough RAM to run the on-device model.
  full,

  /// Too little RAM: retrieval only, no generation.
  searchOnly,
}
