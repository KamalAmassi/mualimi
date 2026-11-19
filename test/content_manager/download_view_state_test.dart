import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/core/services/network_kind.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_phase.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_progress.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_ui_state.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/pack_download_controller.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/pause_reason.dart';

import '../helpers/pack_download_fakes.dart';

Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  late PackDownloadHarness h;
  late PackDownloadController c;

  setUp(() {
    h = PackDownloadHarness();
    c = Get.put(h.build(autoStart: false, networkDebounce: const Duration(milliseconds: 10)));
  });

  tearDown(() {
    h.download.closeAll();
    Get.reset();
  });

  void emit(DownloadPhase phase, {Failure? failure}) => h.download
      .emit(DownloadProgress(phase: phase, bytesDone: 10, totalBytes: 100, failure: failure));

  group('pack', () {
    test('is null before a job and set to the manifest pack once resolved', () async {
      expect(c.pack.value, isNull);
      await c.start();
      expect(c.pack.value, pack(9));
    });

    test('is the offered pack when an update was offered for this grade', () async {
      c.offeredPack.value = pack(9, version: 2);
      await c.start();
      expect(c.pack.value, pack(9, version: 2));
    });

    test('is null when the grade has no pack', () async {
      h.settings.grade.value = 11;
      await c.start();
      expect(c.ui.value, DownloadUiState.failed);
      expect(c.pack.value, isNull);
    });

    test('is null when no grade is selected', () async {
      h.settings.grade.value = null;
      await c.start();
      expect(c.pack.value, isNull);
    });

    test('is kept when the job fails and when it is paused', () async {
      await c.start();
      await c.pause();
      expect(c.pack.value, pack(9));
      await c.resume();
      emit(DownloadPhase.failed, failure: const IntegrityFailure());
      await settle();
      expect(c.pack.value, pack(9));
    });

    test('is cleared by cancel, including a switch to another grade', () async {
      await c.start();
      await c.cancel();
      expect(c.pack.value, isNull);

      await c.start();
      h.settings.grade.value = 10;
      await c.startForCurrentGrade();
      expect(c.pack.value, pack(10));
    });
  });

  group('pauseReason', () {
    void net(NetworkKind kind) => h.connectivity.network.value = kind;

    test('is user after a user pause and null after resume', () async {
      await c.start();
      await c.pause();
      expect(c.pauseReason.value, PauseReason.user);
      await c.resume();
      expect(c.pauseReason.value, isNull);
      expect(c.ui.value, DownloadUiState.downloading);
    });

    test('is network after the network drops mid-download', () async {
      await c.start();
      net(NetworkKind.offline);
      await settle();
      expect(c.pauseReason.value, PauseReason.network);
    });

    test('is network while waiting for the mobile-data choice', () async {
      await c.start();
      net(NetworkKind.mobile);
      await settle();
      expect(c.ui.value, DownloadUiState.awaitingNetworkChoice);
      expect(c.pauseReason.value, PauseReason.network);
    });

    test('notifies listeners when it changes', () async {
      final seen = <PauseReason?>[];
      ever<PauseReason?>(c.pauseReason, seen.add);
      await c.start();
      await c.pause();
      await c.resume();
      await settle();
      // GetX notifies the first assignment even when it keeps the value null.
      expect(seen.skipWhile((r) => r == null), [PauseReason.user, null]);
    });

    test('is cleared when the job fails after a network pause', () async {
      await c.start();
      net(NetworkKind.offline);
      await settle();
      emit(DownloadPhase.failed, failure: const IntegrityFailure());
      await settle();
      expect(c.ui.value, DownloadUiState.failed);
      expect(c.pauseReason.value, isNull);
    });

    test('is cleared when the job runs out of space after a user pause', () async {
      await c.start();
      await c.pause();
      emit(
        DownloadPhase.failed,
        failure: const NotEnoughSpaceFailure(requiredBytes: 2, freeBytes: 1),
      );
      await settle();
      expect(c.ui.value, DownloadUiState.noSpace);
      expect(c.pauseReason.value, isNull);
    });

    test('stays user when a network failure arrives during a user pause', () async {
      await c.start();
      await c.pause();
      emit(DownloadPhase.failed, failure: const NetworkFailure());
      await settle();
      expect(c.ui.value, DownloadUiState.paused);
      expect(c.pauseReason.value, PauseReason.user);
    });

    test('is cleared when the job completes', () async {
      await c.start();
      net(NetworkKind.offline);
      await settle();
      expect(c.pauseReason.value, PauseReason.network);
      emit(DownloadPhase.completed);
      await settle();
      expect(c.ui.value, DownloadUiState.completed);
      expect(c.pauseReason.value, isNull);
    });
  });
}
