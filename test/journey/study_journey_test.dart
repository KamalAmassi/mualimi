import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/controllers/tutor_controller.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/pages/saved_page.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/routes/tutor_args.dart';
import 'package:mualimi/features/lesson/presentation/controllers/viewer_tab.dart';
import 'package:mualimi/features/lesson/presentation/widgets/key_terms_strings.dart';
import 'package:mualimi/features/lesson/presentation/widgets/lesson_hub_strings.dart';
import 'package:mualimi/features/lesson/presentation/widgets/viewer_tab_bar.dart';
import 'package:mualimi/features/profile/presentation/pages/profile_page.dart';
import 'package:mualimi/features/shell/presentation/controllers/shell_controller.dart';

import 'journey_harness.dart';

Finder get _shell => find.byType(NavigationBar);
Finder get _home => find.text(DevSeedScienceG9.subjectName);
Finder get _hub => find.text(LessonHubStrings.explanationTitle);

Future<void> _openLesson(Journey j) async {
  await j.installReturningStudent();
  await j.boot(until: _home);
  await j.tapText(DevSeedScienceG9.subjectName, until: find.text(DevSeedScienceG9.lessonTitle));
  await j.tapText(DevSeedScienceG9.lessonTitle, until: _hub);
}

void main() {
  group('D. study flow', () {
    journeyTest('home -> subject -> lesson -> key terms and back', (j) async {
      await _openLesson(j);
      expect(Get.currentRoute, AppRoutes.lessonOf(DevSeedScienceG9.lessonId));

      await j.tapText(DevSeedScienceG9.chargingByInductionTerm,
          until: find.text(KeyTermsStrings.allTerms));
      expect(Get.currentRoute, AppRoutes.keyTermsOf(DevSeedScienceG9.lessonId));

      await j.back(until: _hub, gone: find.text(KeyTermsStrings.allTerms));
      expect(Get.currentRoute, AppRoutes.lessonOf(DevSeedScienceG9.lessonId));
      await j.back(until: find.text(DevSeedScienceG9.lessonTitle), gone: _hub);
      expect(Get.currentRoute, AppRoutes.subjectOf(DevSeedScienceG9.subjectId));
      await j.back(until: _shell, gone: find.text(DevSeedScienceG9.lessonTitle));
      expect(Get.currentRoute, AppRoutes.shell);
    });

    journeyTest('lesson -> viewer with its three tabs and back', (j) async {
      await _openLesson(j);
      await j.tapText(LessonHubStrings.explanationTitle, until: find.byType(ViewerTabBar));
      expect(Get.currentRoute, startsWith('/viewer/'));

      for (final tab in ViewerTab.values) {
        await j.tapText(tab.label,
            until: find.byWidgetPredicate((w) => w is ViewerTabBar && w.selected == tab));
        expect(find.text(tab.label), findsOneWidget);
      }

      await j.back(until: _hub, gone: find.byType(ViewerTabBar));
      expect(Get.currentRoute, AppRoutes.lessonOf(DevSeedScienceG9.lessonId));
    });
  });

  group('E. lesson -> tutor', () {
    journeyTest(
      'Ask the tutor opens AppRoutes.tutor on top of the lesson; back returns to it',
      (j) async {
        await _openLesson(j);
        await j.tapText(LessonHubStrings.askTutorTitle, until: find.text(AppStrings.askHint));

        expect(Get.currentRoute, AppRoutes.tutor);
        expect(find.byIcon(LucideIcons.arrowRight), findsOneWidget, reason: 'back button');
        expect(find.text(DevSeedScienceG9.lessonTitle), findsWidgets);

        await j.back(until: _hub, gone: find.text(AppStrings.askHint));
        expect(Get.currentRoute, AppRoutes.lessonOf(DevSeedScienceG9.lessonId));
        expect(Get.find<ShellController>().index.value, ShellController.subjectsTab);
      },
    );

    journeyTest('the tutor route opens over the lesson with subject and lesson selected',
        (j) async {
      await _openLesson(j);
      Get.toNamed<void>(
        AppRoutes.tutor,
        arguments: const TutorArgs(
          subjectId: DevSeedScienceG9.subjectId,
          lessonId: DevSeedScienceG9.lessonId,
        ),
      );
      await j.pumpUntil(find.text(AppStrings.askHint));

      expect(Get.currentRoute, AppRoutes.tutor);
      expect(find.text(AppStrings.askHint), findsOneWidget);
      expect(find.text(DevSeedScienceG9.lessonTitle), findsWidgets);
      expect(Get.find<TutorController>().selection.lessonId.value, DevSeedScienceG9.lessonId);

      await j.back(until: _hub, gone: find.text(AppStrings.askHint));
      expect(Get.currentRoute, AppRoutes.lessonOf(DevSeedScienceG9.lessonId));
      expect(Get.find<ShellController>().index.value, ShellController.subjectsTab);
    });
  });

  group('F. shell tabs', () {
    journeyTest('subjects, tutor and profile tabs switch; saved opens from the tutor',
        (j) async {
      await j.installReturningStudent();
      await j.boot(until: _home);
      final shell = Get.find<ShellController>();

      await j.tapText(AppStrings.smartTutor, until: find.text(AppStrings.askHint));
      expect(shell.index.value, ShellController.tutorTab);

      await j.tapText(AppStrings.profile, until: find.byType(ProfilePage));
      expect(shell.index.value, ShellController.profileTab);

      await j.tapText(AppStrings.subjects, until: find.text(DevSeedScienceG9.subjectName));
      expect(shell.index.value, ShellController.subjectsTab);
      expect(find.text(DevSeedScienceG9.subjectName), findsOneWidget);

      await j.tapText(AppStrings.smartTutor, until: find.text(AppStrings.askHint));
      await j.tester.tap(find.byIcon(LucideIcons.bookmark));
      await j.pumpUntil(find.byType(SavedPage));
      expect(Get.currentRoute, AppRoutes.saved);

      await j.back(until: find.text(AppStrings.askHint), gone: find.byType(SavedPage));
      expect(Get.currentRoute, AppRoutes.shell);
      expect(shell.index.value, ShellController.tutorTab);
    });
  });
}
