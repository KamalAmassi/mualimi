import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/constants/limits.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_skills_charges.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/usecase/usecase.dart';
import 'package:mualimi/features/gap_filling/domain/entities/diagnostic_answer.dart';
import 'package:mualimi/features/gap_filling/domain/usecases/finish_diagnostic_usecase.dart';
import 'package:mualimi/features/gap_filling/domain/usecases/submit_skill_review_usecase.dart';
import 'package:mualimi/features/gap_filling/presentation/controllers/skill_progress_signal.dart';
import 'package:mualimi/features/gap_filling/presentation/widgets/gap_filling_strings.dart';
import 'package:mualimi/features/gap_filling/presentation/widgets/learning_path_card.dart';
import 'package:mualimi/features/gap_filling/presentation/widgets/lesson_prerequisites_card.dart';
import 'package:mualimi/features/gap_filling/presentation/widgets/skill_tile.dart';

import 'gap_filling_app.dart';
import 'gap_filling_harness.dart';

void main() {
  final h = GapFillingHarness();

  /// A finished diagnostic where every question was right, or "I do not know".
  Future<void> takeDiagnostic({required bool right}) async {
    final session =
        (await h.start(const NoParams())).getOrElse(() => throw StateError('start'));
    final answers = {
      for (final plan in session.plans)
        for (final q in plan.questions)
          q.id: DiagnosticAnswer(
              questionId: q.id, choiceIndex: right ? q.answerIndex : null),
    };
    await h.finish(FinishDiagnosticParams(session, answers));
  }

  /// Seeds the databases, optionally takes a diagnostic, then shows [host].
  Future<void> open(WidgetTester tester, Widget host, {bool? diagnosticRight}) async {
    await tester.runAsync(() async {
      await h.open();
      if (diagnosticRight != null) await takeDiagnostic(right: diagnosticRight);
    });
    await pumpGapFillingApp(tester, h, host: host);
  }

  tearDown(() async {
    Get.reset();
    await h.close();
  });

  group('LearningPathCard', () {
    testWidgets('without a diagnostic it invites the student to take it', (tester) async {
      await open(tester, const LearningPathCard());
      expect(find.text(GapFillingStrings.pathInviteTitle), findsOneWidget);
      expect(find.byType(SkillTile), findsNothing);
      await tapText(tester, GapFillingStrings.pathInviteAction);
      expect(Get.currentRoute, AppRoutes.diagnostic);
      expect(find.text(GapFillingStrings.introTitle), findsOneWidget);
    });

    testWidgets('with weak skills it shows the first ones and opens a review',
        (tester) async {
      await open(tester, const LearningPathCard(), diagnosticRight: false);
      expect(find.text(GapFillingStrings.pathCardTitle), findsOneWidget);
      expect(find.byType(SkillTile), findsNWidgets(Limits.learningPathSize));
      expect(find.text('الشحنات الكهربائية'), findsOneWidget);
      await tapText(tester, 'الشحنات الكهربائية');
      expect(Get.currentRoute, AppRoutes.skillReview);
      expect(find.text(GapFillingStrings.startQuestions), findsOneWidget);
    });

    testWidgets('with nothing to review it says so', (tester) async {
      await open(tester, const LearningPathCard(), diagnosticRight: true);
      expect(find.text(GapFillingStrings.pathAllGood), findsOneWidget);
      expect(find.byType(SkillTile), findsNothing);
    });

    testWidgets('it follows a review that strengthens a skill', (tester) async {
      await open(tester, const LearningPathCard(), diagnosticRight: false);
      expect(find.text('تركيب الذرة'), findsNothing);
      await tester.runAsync(() => h.submit(const SubmitSkillReviewParams(
          skillId: chargesSkillId, correct: 2, asked: 2)));
      Get.find<SkillProgressSignal>().changed();
      await settle(tester);
      expect(find.text('الشحنات الكهربائية'), findsNothing);
      expect(find.byType(SkillTile), findsNWidgets(Limits.learningPathSize));
    });
  });

  group('LessonPrerequisitesCard', () {
    const lesson = DevSeedScienceG9.lessonId;

    testWidgets('is hidden when no diagnostic was taken', (tester) async {
      await open(tester, const LessonPrerequisitesCard(lesson));
      expect(find.text(GapFillingStrings.prerequisitesTitle), findsNothing);
      expect(find.byType(SkillTile), findsNothing);
    });

    testWidgets('is hidden when no prerequisite is weak', (tester) async {
      await open(tester, const LessonPrerequisitesCard(lesson), diagnosticRight: true);
      expect(find.text(GapFillingStrings.prerequisitesTitle), findsNothing);
    });

    testWidgets('is hidden for a lesson without prerequisites', (tester) async {
      await open(tester, const LessonPrerequisitesCard(DevSeedScienceG9.mathLessonId),
          diagnosticRight: false);
      expect(find.text(GapFillingStrings.prerequisitesTitle), findsNothing);
    });

    testWidgets('lists the weak prerequisites with their grade and opens a review',
        (tester) async {
      await open(tester, const LessonPrerequisitesCard(lesson), diagnosticRight: false);
      expect(find.text(GapFillingStrings.prerequisitesTitle), findsOneWidget);
      expect(find.byType(SkillTile), findsNWidgets(3));
      expect(find.text('تركيب الذرة'), findsOneWidget);
      expect(find.text('من الصف السابع'), findsOneWidget);
      await tapText(tester, 'تركيب الذرة');
      expect(Get.currentRoute, AppRoutes.skillReview);
    });

    testWidgets('a skill leaves the card once it is strong again', (tester) async {
      await open(tester, const LessonPrerequisitesCard(lesson), diagnosticRight: false);
      await tester.runAsync(() => h.submit(const SubmitSkillReviewParams(
          skillId: atomSkillId, correct: 2, asked: 2)));
      Get.find<SkillProgressSignal>().changed();
      await settle(tester);
      expect(find.byType(SkillTile), findsNWidgets(2));
      expect(find.text('تركيب الذرة'), findsNothing);
    });
  });
}
