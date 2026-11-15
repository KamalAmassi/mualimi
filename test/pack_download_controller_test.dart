import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/features/content_manager/presentation/bindings/download_binding.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_ui_state.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/pack_download_controller.dart';

import 'helpers/pack_download_fakes.dart';

/// Lets queued microtasks and async gaps (manifest load, binding start) run.
Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  // Only the first-run case needs frames (onReady); the rest are plain tests
  // because widget tests' fake async stalls after a canceled stream.
  TestWidgetsFlutterBinding.ensureInitialized();
  late PackDownloadHarness h;

  setUp(() => h = PackDownloadHarness());

  tearDown(() {
    h.download.closeAll();
    Get.reset();
  });

  /// What ContentManagerShellBinding registers once `/shell` opens.
  void registerLikeShell() => Get.lazyPut<PackDownloadController>(
        () => h.build(autoStart: false),
        fenix: true,
      );

  testWidgets('first run: entering /download auto-starts the current grade', (tester) async {
    DownloadBinding.attach(() => h.build(autoStart: true));
    final c = Get.find<PackDownloadController>();
    tester.binding.scheduleFrame(); // the route transition does this in the app
    await tester.pump(); // onReady runs after the frame
    await tester.pump(); // ...then the manifest loads and the job starts

    expect(h.download.files, ['pack-9-v1.zip']);
    expect(c.ui.value, DownloadUiState.downloading);
  });

  test('after the shell registered it, a grade change + /download starts the new grade',
      () async {
    registerLikeShell();
    final shellController = Get.find<PackDownloadController>();
    await shellController.checkForUpdate();
    expect(shellController.offeredPack.value?.grade, 9, reason: 'update sheet offered; "Later"');
    expect(h.download.jobs, isEmpty);

    h.settings.grade.value = 10; // ProfileController.changeGrade
    DownloadBinding.attach(() => h.build(autoStart: true));
    await settle();

    expect(h.created, 1, reason: 'the shell controller is reused, not replaced');
    expect(Get.find<PackDownloadController>(), same(shellController));
    expect(h.download.files, ['pack-10-v1.zip']);
    expect(shellController.ui.value, DownloadUiState.downloading);
  });

  test('a grade change clears the offered pack', () async {
    final c = h.build(autoStart: false);
    Get.put(c);
    await c.checkForUpdate();
    expect(c.offeredPack.value?.grade, 9);

    h.settings.grade.value = 10;
    expect(c.offeredPack.value, isNull);
  });

  test('a stale offer for another grade is never downloaded', () async {
    final c = h.build(autoStart: false);
    Get.put(c);
    h.settings.grade.value = 10;
    c.offeredPack.value = pack(9, version: 2); // e.g. a late update-check result

    await c.startForCurrentGrade();

    expect(h.download.files, ['pack-10-v1.zip']);
    expect(c.offeredPack.value, isNull);
  });

  test('an offer for the current grade is still what "Update now" downloads',
      () async {
    final c = h.build(autoStart: false);
    Get.put(c);
    await c.checkForUpdate();

    await c.start();

    expect(h.download.files, ['pack-9-v2.zip']);
  });

  test('a second start while busy does not start a second job', () async {
    final c = h.build(autoStart: false);
    Get.put(c);

    final first = c.start();
    final second = c.start(); // while the manifest is still loading
    await Future.wait([first, second]);
    await c.start(); // while downloading
    await c.startForCurrentGrade(); // re-entering /download for the same grade

    expect(h.download.jobs, hasLength(1));
    expect(h.cancel.calls, 0);
  });

  test('a job running for the old grade is canceled before the new grade starts',
      () async {
    final c = h.build(autoStart: false);
    Get.put(c);
    await c.start();
    expect(c.isBusy, isTrue);

    h.settings.grade.value = 10;
    await c.startForCurrentGrade();

    expect(h.cancel.calls, 1);
    expect(h.download.files, ['pack-9-v1.zip', 'pack-10-v1.zip']);
  });
}
