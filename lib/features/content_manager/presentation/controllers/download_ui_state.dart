enum DownloadUiState {
  idle,
  awaitingNetworkChoice,
  waitingForWifi,
  downloading,
  paused,
  verifying,
  assembling,
  noSpace,
  failed,
  completed,
}

extension DownloadUiStateBusy on DownloadUiState {
  /// A job exists (or is about to) and must not be started a second time.
  bool get isBusy => switch (this) {
        DownloadUiState.awaitingNetworkChoice ||
        DownloadUiState.waitingForWifi ||
        DownloadUiState.downloading ||
        DownloadUiState.paused ||
        DownloadUiState.verifying ||
        DownloadUiState.assembling =>
          true,
        DownloadUiState.idle ||
        DownloadUiState.noSpace ||
        DownloadUiState.failed ||
        DownloadUiState.completed =>
          false,
      };
}
