/// Outcome of asking the server whether the installed pack is current.
enum PackUpdateCheck {
  upToDate,
  updateAvailable,

  /// Offline, no manifest, or no grade chosen: nothing is known.
  unavailable,
}
