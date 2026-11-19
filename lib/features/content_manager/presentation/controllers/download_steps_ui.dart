import '../../../../core/error/failures.dart';
import '../widgets/download_step_state.dart';
import 'download_ui_state.dart';

const _pending = DownloadStepState.pending;
const _active = DownloadStepState.active;
const _done = DownloadStepState.done;
const _error = DownloadStepState.error;

extension DownloadStepsUi on DownloadUiState {
  /// The checklist rows in order: space check, download, integrity check,
  /// install. [jobStarted] (bytes arrived, e.g. `bytesDone > 0`) tells a wait
  /// for the network before the job from one in the middle of it, since the
  /// space check runs only once the job starts. Install stays pending until
  /// the whole download completes.
  List<DownloadStepState> stepsFor(Failure? failure, {required bool jobStarted}) =>
      switch (this) {
        DownloadUiState.idle => const [_pending, _pending, _pending, _pending],
        DownloadUiState.awaitingNetworkChoice ||
        DownloadUiState.waitingForWifi ||
        DownloadUiState.paused =>
          jobStarted
              ? const [_done, _active, _pending, _pending]
              : const [_pending, _pending, _pending, _pending],
        DownloadUiState.downloading => const [_done, _active, _pending, _pending],
        DownloadUiState.verifying ||
        DownloadUiState.assembling =>
          const [_done, _done, _active, _pending],
        DownloadUiState.noSpace => const [_error, _pending, _pending, _pending],
        DownloadUiState.failed => switch (failure) {
            NotEnoughSpaceFailure() => const [_error, _pending, _pending, _pending],
            IntegrityFailure() => const [_done, _done, _error, _pending],
            _ => const [_done, _error, _pending, _pending],
          },
        DownloadUiState.completed => const [_done, _done, _done, _done],
      };
}
