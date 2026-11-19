import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/constants/app_files.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_loader.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_phase.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_progress.dart';
import 'package:mualimi/features/content_manager/presentation/constants/download_strings.dart';
import 'package:mualimi/features/content_manager/presentation/constants/grade_ordinals.dart';
import 'package:mualimi/features/onboarding/presentation/widgets/grade_strings.dart';
import 'package:mualimi/features/shell/presentation/controllers/shell_controller.dart';

import 'journey_harness.dart';

Future<void> _walkToDownload(Journey j) async {
  await j.tester.enterText(find.byType(TextField), 'سلمى');
  await j.tapText(AppStrings.next);
  expect(find.text(GradeOrdinals.of(9)), findsOneWidget);
  await j.tapText(GradeOrdinals.of(9));
  await j.tapText(GradeStrings.downloadLabel(9));
}

void main() {
  group('A. first launch', () {
    journeyTest('splash -> welcome -> grade -> download -> shell, and back never returns',
        (j) async {
      await j.boot();
      expect(Get.currentRoute, AppRoutes.welcome);
      expect(find.byType(TextField), findsOneWidget);

      await j.tester.enterText(find.byType(TextField), 'سلمى');
      await j.tapText(AppStrings.next);
      expect(Get.currentRoute, AppRoutes.grade);

      await j.tapText(GradeOrdinals.of(9));
      await j.tapText(GradeStrings.downloadLabel(9));

      expect(Get.currentRoute, AppRoutes.shell);
      expect(find.text(DevSeedScienceG9.subjectName), findsOneWidget, reason: 'Home tab');
      expect(j.atStackRoot, isTrue, reason: 'splash, welcome, grade, download are gone');
      expect(find.byType(NavigationBar), findsOneWidget);

      await j.tester.binding.handlePopRoute();
      await j.settle();
      expect(Get.currentRoute, isNot(anyOf(AppRoutes.splash, AppRoutes.welcome,
          AppRoutes.grade, AppRoutes.download)));
    });

    journeyTest('finishing the download marks onboarding done', (j) async {
      await j.boot();
      await _walkToDownload(j);
      final settings =
          jsonDecode(File('${j.root.path}/${AppFiles.settingsFile}').readAsStringSync())
              as Map<String, dynamic>;
      expect(settings['onboarding_done'], isTrue);
      expect(j.download.jobs, 1);
    });

    journeyTest('an empty name keeps the student on welcome', (j) async {
      await j.boot();
      await j.tapText(AppStrings.next);
      expect(Get.currentRoute, AppRoutes.welcome);
      expect(find.text(AppStrings.studentNameInvalid), findsOneWidget);
    });

    journeyTest(
      'onboarding done but pack missing restarts at welcome',
      (j) async {
        File('${j.root.path}/${AppFiles.settingsFile}')
            .writeAsStringSync(jsonEncode({'onboarding_done': true, 'grade': 9}));
        await j.boot();
        expect(Get.currentRoute, AppRoutes.welcome);
      },
    );
  });

  group('B. returning user', () {
    journeyTest('splash goes straight to the shell on the Home tab', (j) async {
      await j.installReturningStudent();
      await j.boot();
      expect(Get.currentRoute, AppRoutes.shell);
      expect(find.text(DevSeedScienceG9.subjectName), findsOneWidget);
      expect(Get.find<ShellController>().index.value, ShellController.subjectsTab);
      expect(j.atStackRoot, isTrue);
      expect(j.download.jobs, 0, reason: 'no download for an installed pack');
    });
  });

  group('C. download states', () {
    journeyTest('paused shows resume and cancel', (j) async {
      await j.boot();
      await _walkToDownload(j);
      expect(Get.currentRoute, AppRoutes.download);
      expect(find.text(AppStrings.downloadPaused), findsOneWidget);
      expect(find.text(AppStrings.resume), findsOneWidget);
      expect(find.text(AppStrings.cancel), findsOneWidget);
    }, script: pausedScript);

    journeyTest('cancel on the paused screen returns to a startable download screen',
        (j) async {
      await j.boot();
      await _walkToDownload(j);
      await j.tapText(AppStrings.cancel);
      expect(Get.currentRoute, AppRoutes.download);
      expect(find.text(AppStrings.startDownload), findsOneWidget);
    }, script: pausedScript);

    journeyTest('no-space retry continues into the shell once space is free', (j) async {
      await j.boot();
      await _walkToDownload(j);
      expect(find.text(DownloadStrings.noSpaceTitle), findsOneWidget);
      j.download.script = completedScript;
      await j.tapText(DownloadStrings.checkAgain);
      expect(Get.currentRoute, AppRoutes.shell);
      expect(j.atStackRoot, isTrue);
    }, script: noSpaceScript);

    journeyTest('failed retry continues into the shell once it works', (j) async {
      await j.boot();
      await _walkToDownload(j);
      expect(find.text(AppStrings.downloadFailed), findsOneWidget);
      j.download.script = completedScript;
      await j.tapText(AppStrings.retry);
      expect(Get.currentRoute, AppRoutes.shell);
      expect(j.atStackRoot, isTrue);
    }, script: failedScript);

    test('scripts used above cover every failure phase', () {
      expect(
        [pausedScript, noSpaceScript, failedScript].expand((s) => s).map((p) => p.phase),
        containsAll([DownloadPhase.paused, DownloadPhase.failed]),
      );
      expect(const DownloadProgress(phase: DownloadPhase.completed).isFinal, isTrue);
    });
  });

  group('G. DEV_SEED', () {
    journeyTest('with the seed the app starts at /shell with the development data',
        (j) async {
      await j.boot(devSeed: true);
      expect(Get.currentRoute, AppRoutes.shell);
      expect(find.text(DevSeedScienceG9.subjectName), findsOneWidget);
      expect(j.download.jobs, 0);
    });

    journeyTest('without the seed journey A runs', (j) async {
      await j.boot();
      expect(Get.currentRoute, AppRoutes.welcome);
    });

    test('the flag is honoured outside release only', () {
      expect(
          DevSeedLoader.isEnabled(releaseMode: false, flagSet: true), isTrue);
      expect(
          DevSeedLoader.isEnabled(releaseMode: true, flagSet: true), isFalse);
      expect(
          DevSeedLoader.isEnabled(releaseMode: false, flagSet: false), isFalse);
    });
  });
}
