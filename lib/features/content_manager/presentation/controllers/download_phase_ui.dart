import '../../domain/entities/download_phase.dart';
import 'download_ui_state.dart';

extension DownloadPhaseUi on DownloadPhase {
  /// The screen state for a progress event. [DownloadPhase.failed] maps to
  /// [DownloadUiState.failed]; the controller refines it to `noSpace` when needed.
  DownloadUiState get uiState => switch (this) {
        DownloadPhase.downloading => DownloadUiState.downloading,
        DownloadPhase.paused => DownloadUiState.paused,
        DownloadPhase.verifying => DownloadUiState.verifying,
        DownloadPhase.assembling => DownloadUiState.assembling,
        DownloadPhase.canceled => DownloadUiState.idle,
        DownloadPhase.failed => DownloadUiState.failed,
        DownloadPhase.completed => DownloadUiState.completed,
      };
}
