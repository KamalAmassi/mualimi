import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/core/services/network_kind.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_phase.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_progress.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_ui_state.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/pack_download_controller.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/pause_reason.dart';

import 'helpers/pack_download_fakes.dart';

const _debounce = Duration(milliseconds: 40);

Future<void> settle() => Future<void>.delayed(Duration.zero);

/// Long enough for the debounce to fire and the resume to run.
Future<void> afterDebounce() => Future<void>.delayed(_debounce * 3);

void main() {
  late PackDownloadHarness h;
  late PackDownloadController c;

  setUp(() {
    h = PackDownloadHarness();
    c = Get.put(h.build(autoStart: false, networkDebounce: _debounce));
  });

  tearDown(() {
    h.download.closeAll();
    Get.reset();
  });

  void net(NetworkKind kind) => h.connectivity.network.value = kind;

  test('network drop pauses for the network; its return resumes once after the debounce',
      () async {
    await c.start();
    net(NetworkKind.offline);
    await settle();
    expect(c.ui.value, DownloadUiState.paused);
    expect(c.pauseReason, PauseReason.network);
    expect(h.pause.calls, 1);

    net(NetworkKind.wifi);
    await settle();
    expect(h.resume.calls, 0, reason: 'still inside the debounce window');

    await afterDebounce();
    expect(h.resume.calls, 1);
    expect(c.ui.value, DownloadUiState.downloading);
    expect(c.pauseReason, isNull);
    expect(h.download.jobs, hasLength(1));
  });

  test('a user pause is never auto-resumed, even when the network flaps', () async {
    await c.start();
    await c.pause();
    for (final k in [NetworkKind.offline, NetworkKind.wifi, NetworkKind.offline, NetworkKind.wifi]) {
      net(k);
      await afterDebounce();
    }
    expect(c.ui.value, DownloadUiState.paused);
    expect(c.pauseReason, PauseReason.user);
    expect(h.resume.calls, 0);
  });

  test('offline at start waits instead of failing, then starts when the network returns',
      () async {
    net(NetworkKind.offline);
    await c.start();
    expect(c.ui.value, DownloadUiState.paused);
    expect(c.pauseReason, PauseReason.network);
    expect(h.download.jobs, isEmpty);

    await c.startForCurrentGrade(); // re-entering /download: still one waiting job
    net(NetworkKind.wifi);
    await afterDebounce();
    expect(h.download.files, ['pack-9-v1.zip']);
    expect(c.ui.value, DownloadUiState.downloading);
  });

  test('Wi-Fi → mobile mid-download asks; approval resets on Wi-Fi', () async {
    await c.start();
    net(NetworkKind.mobile);
    await settle();
    expect(c.ui.value, DownloadUiState.awaitingNetworkChoice);
    expect(h.pause.calls, 1);

    await afterDebounce();
    expect(h.resume.calls, 0, reason: 'mobile data needs approval first');

    c.continueOnMobile();
    await settle();
    expect(h.resume.calls, 1);
    expect(c.ui.value, DownloadUiState.downloading);

    net(NetworkKind.wifi);
    await afterDebounce();
    net(NetworkKind.mobile);
    await settle();
    expect(c.ui.value, DownloadUiState.awaitingNetworkChoice, reason: 'asked again');
    expect(h.pause.calls, 2);
    expect(h.download.jobs, hasLength(1));
  });

  test('rapid flapping inside the debounce window resumes once', () async {
    await c.start();
    net(NetworkKind.offline);
    for (final k in [NetworkKind.wifi, NetworkKind.offline, NetworkKind.wifi, NetworkKind.offline]) {
      net(k);
      await settle();
    }
    net(NetworkKind.wifi);
    await afterDebounce();
    await afterDebounce();
    expect(h.resume.calls, 1);
    expect(c.ui.value, DownloadUiState.downloading);
  });

  test('a job that failed on the network restarts when the network returns', () async {
    await c.start();
    net(NetworkKind.offline);
    h.download.emit(const DownloadProgress(phase: DownloadPhase.failed, failure: NetworkFailure()));
    await settle();
    expect(c.ui.value, DownloadUiState.paused);
    expect(c.pauseReason, PauseReason.network);

    net(NetworkKind.wifi);
    await afterDebounce();
    expect(h.resume.calls, 0, reason: 'the old job is gone');
    expect(h.download.jobs, hasLength(2));
    expect(c.ui.value, DownloadUiState.downloading);
  });

  test('a network failure seen before the offline event still waits for the network',
      () async {
    await c.start();
    h.download.emit(const DownloadProgress(phase: DownloadPhase.failed, failure: NetworkFailure()));
    await settle();
    expect(c.ui.value, DownloadUiState.failed);

    net(NetworkKind.offline);
    await settle();
    expect(c.ui.value, DownloadUiState.paused);
    net(NetworkKind.wifi);
    await afterDebounce();
    expect(h.download.jobs, hasLength(2));
  });
}
