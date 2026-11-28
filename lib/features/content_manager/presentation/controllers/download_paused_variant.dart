import 'download_ui_state.dart';
import 'pause_reason.dart';

/// Which paused screen to show: stopped by the user, waiting for the
/// network to come back, or waiting for Wi-Fi instead of mobile data.
enum DownloadPausedVariant {
  user,
  network,
  wifi;

  /// A pause with no recorded reason (reported by the engine) waits for the
  /// user like a user pause, since nothing will resume it on its own.
  static DownloadPausedVariant of(DownloadUiState state, PauseReason? reason) {
    if (state == DownloadUiState.waitingForWifi) return wifi;
    return reason == PauseReason.network ? network : user;
  }
}
