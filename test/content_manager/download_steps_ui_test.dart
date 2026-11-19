import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_steps_ui.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_ui_state.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_state.dart';

const p = DownloadStepState.pending;
const a = DownloadStepState.active;
const d = DownloadStepState.done;
const e = DownloadStepState.error;

const _noSpace = NotEnoughSpaceFailure(requiredBytes: 2, freeBytes: 1);

void main() {
  void expectSteps(
    DownloadUiState ui,
    List<DownloadStepState> steps, {
    Failure? failure,
    List<bool> jobStarted = const [false, true],
  }) {
    for (final started in jobStarted) {
      expect(ui.stepsFor(failure, jobStarted: started), steps,
          reason: '$ui, failure: $failure, jobStarted: $started');
    }
  }

  test('idle: every step pending', () => expectSteps(DownloadUiState.idle, [p, p, p, p]));

  group('waiting on the network or paused', () {
    const waits = [
      DownloadUiState.awaitingNetworkChoice,
      DownloadUiState.waitingForWifi,
      DownloadUiState.paused,
    ];

    test('before the job started: every step pending, space not checked yet', () {
      for (final ui in waits) {
        expectSteps(ui, [p, p, p, p], jobStarted: [false]);
      }
    });

    test('mid-job: space done, download active', () {
      for (final ui in waits) {
        expectSteps(ui, [d, a, p, p], jobStarted: [true]);
      }
    });
  });

  test('downloading: space done, download active',
      () => expectSteps(DownloadUiState.downloading, [d, a, p, p]));

  test('verifying and assembling: integrity check active, install pending', () {
    expectSteps(DownloadUiState.verifying, [d, d, a, p]);
    expectSteps(DownloadUiState.assembling, [d, d, a, p]);
  });

  test('noSpace: space check error',
      () => expectSteps(DownloadUiState.noSpace, [e, p, p, p], failure: _noSpace));

  group('failed', () {
    test('NotEnoughSpaceFailure: space check error',
        () => expectSteps(DownloadUiState.failed, [e, p, p, p], failure: _noSpace));

    test('IntegrityFailure: integrity check error', () {
      expectSteps(DownloadUiState.failed, [d, d, e, p], failure: const IntegrityFailure());
    });

    test('any other failure, or none: download error', () {
      for (final f in const <Failure?>[
        NetworkFailure(),
        StorageFailure(),
        ManifestFailure(),
        NotFoundFailure(),
        null,
      ]) {
        expectSteps(DownloadUiState.failed, [d, e, p, p], failure: f);
      }
    });
  });

  test('completed: every step done, including install',
      () => expectSteps(DownloadUiState.completed, [d, d, d, d]));

  test('every ui state yields four steps', () {
    for (final ui in DownloadUiState.values) {
      expect(ui.stepsFor(null, jobStarted: true), hasLength(4));
      expect(ui.stepsFor(null, jobStarted: false), hasLength(4));
    }
  });
}
