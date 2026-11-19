import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_skills_charges.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/features/gap_filling/domain/entities/diagnostic_question.dart';
import 'package:mualimi/features/gap_filling/domain/entities/question_kind.dart';
import 'package:mualimi/features/gap_filling/presentation/routes/skill_review_args.dart';
import 'package:mualimi/features/gap_filling/presentation/widgets/gap_filling_strings.dart';

import 'gap_filling_app.dart';
import 'gap_filling_harness.dart';

void main() {
  final h = GapFillingHarness();
  late List<DiagnosticQuestion> questions;

  Future<void> open(WidgetTester tester, {String? lessonId}) async {
    await tester.runAsync(h.open);
    questions = (await tester.runAsync(() async => (await h.catalog
            .getQuestions(QuestionKind.review, skillId: atomSkillId))
        .getOrElse(() => const [])))!;
    await pumpGapFillingApp(tester, h);
    Get.toNamed(AppRoutes.skillReview,
        arguments: SkillReviewArgs(skillId: atomSkillId, lessonId: lessonId));
    await settle(tester);
  }

  /// Answers every review question, right or wrong, checking the feedback.
  Future<void> answerQuestions(WidgetTester tester, {required bool right}) async {
    await tapText(tester, GapFillingStrings.startQuestions);
    for (var i = 0; i < questions.length; i++) {
      final q = visibleQuestion(questions);
      final choice = right ? q.answerIndex : (q.answerIndex + 1) % q.choices.length;
      await tapText(tester, q.choices[choice]);
      if (right) {
        expect(find.text(GapFillingStrings.correct), findsOneWidget);
      } else {
        expect(find.text(q.explanation), findsOneWidget);
      }
      await tapText(
          tester,
          i == questions.length - 1
              ? GapFillingStrings.seeResult
              : GapFillingStrings.next);
    }
  }

  tearDown(() async {
    Get.reset();
    await h.close();
  });

  testWidgets('shows the skill, its original grade and the mini lesson text',
      (tester) async {
    await open(tester);
    expect(find.text('تركيب الذرة'), findsOneWidget);
    expect(find.text('من الصف السابع'), findsOneWidget);
    expect(find.text('من ماذا تتكون الذرة؟'), findsOneWidget);
    expect(find.textContaining('أصغر وحدة بناء في المادة'), findsOneWidget);
    expect(find.textContaining('البروتون موجب'), findsOneWidget);
    expect(find.textContaining('**'), findsNothing);
    expect(find.text(GapFillingStrings.startQuestions), findsOneWidget);
  });

  testWidgets('a good review ends with encouragement and a way back', (tester) async {
    await open(tester);
    await answerQuestions(tester, right: true);
    expect(find.text(GapFillingStrings.reviewStronger), findsOneWidget);
    expect(find.text(GapFillingStrings.reviewAgain), findsNothing);
    await tapText(tester, GapFillingStrings.back);
    expect(Get.currentRoute, hostRoute);
    final mastery = (await tester.runAsync(() => h.user.select(h.user.skillMastery).get()))!;
    expect(mastery.single.skillId, atomSkillId);
    expect(mastery.single.score, 100);
    expect(mastery.single.source, 'review');
  });

  testWidgets('from a lesson the way back is labelled for the lesson',
      (tester) async {
    await open(tester, lessonId: DevSeedScienceG9.lessonId);
    await answerQuestions(tester, right: true);
    expect(find.text(GapFillingStrings.backToLesson), findsOneWidget);
    await tapText(tester, GapFillingStrings.backToLesson);
    expect(Get.currentRoute, hostRoute);
  });

  testWidgets('a review that is not enough yet can be repeated', (tester) async {
    await open(tester);
    await answerQuestions(tester, right: false);
    expect(find.text(GapFillingStrings.reviewTryLater), findsOneWidget);
    expect(find.text(GapFillingStrings.reviewStronger), findsNothing);

    await tapText(tester, GapFillingStrings.reviewAgain);
    expect(find.text(GapFillingStrings.startQuestions), findsOneWidget);
    await answerQuestions(tester, right: true);
    expect(find.text(GapFillingStrings.reviewStronger), findsOneWidget);
    final mastery = (await tester.runAsync(() => h.user.select(h.user.skillMastery).get()))!;
    expect(mastery.single.score, 100);
  });

  testWidgets('a poor review can leave without repeating', (tester) async {
    await open(tester);
    await answerQuestions(tester, right: false);
    await tapText(tester, GapFillingStrings.back);
    expect(Get.currentRoute, hostRoute);
  });

  testWidgets('an unknown skill shows a calm message instead of an error',
      (tester) async {
    await tester.runAsync(h.open);
    await pumpGapFillingApp(tester, h);
    Get.toNamed(AppRoutes.skillReview,
        arguments: const SkillReviewArgs(skillId: 'missing'));
    await settle(tester);
    expect(find.text(GapFillingStrings.loadFailedTitle), findsOneWidget);
    await tapText(tester, GapFillingStrings.back);
    expect(Get.currentRoute, hostRoute);
  });
}
