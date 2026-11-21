import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/gap_filling/domain/entities/diagnostic_question.dart';
import 'package:mualimi/features/gap_filling/domain/entities/question_kind.dart';
import 'package:mualimi/features/gap_filling/presentation/routes/diagnostic_args.dart';
import 'package:mualimi/features/gap_filling/presentation/widgets/gap_filling_strings.dart';

import 'gap_filling_app.dart';
import 'gap_filling_harness.dart';

void main() {
  final h = GapFillingHarness();
  late List<DiagnosticQuestion> questions;

  Future<void> open(WidgetTester tester, DiagnosticEntry entry,
      {ThemeData? theme}) async {
    await tester.runAsync(h.open);
    questions = (await tester.runAsync(
            () async => (await h.catalog.getQuestions(QuestionKind.diagnostic))
                .getOrElse(() => const [])))!;
    await pumpGapFillingApp(tester, h, theme: theme);
    Get.toNamed(AppRoutes.diagnostic, arguments: DiagnosticArgs(entry: entry));
    await settle(tester);
  }

  Future<void> answerAll(WidgetTester tester, String how, {int? limit}) async {
    var done = 0;
    while (find.text(GapFillingStrings.next).evaluate().isNotEmpty ||
        find.text(GapFillingStrings.dividerContinue).evaluate().isNotEmpty) {
      if (limit != null && done == limit) return;
      if (find.text(GapFillingStrings.dividerContinue).evaluate().isNotEmpty) {
        await tapText(tester, GapFillingStrings.dividerContinue);
        continue;
      }
      await answerDiagnostic(tester, questions,
          how: how,
          nextLabel: GapFillingStrings.next,
          skipLabel: GapFillingStrings.dontKnow);
      done++;
    }
  }

  tearDown(() async {
    Get.reset();
    await h.close();
  });

  testWidgets('the intro explains the diagnostic and lists the subjects with a time',
      (tester) async {
    await open(tester, DiagnosticEntry.onboarding);
    expect(find.text('خلّينا نعرف من وين نبدأ'), findsOneWidget);
    expect(
        find.text(
            'أسئلة قصيرة عن مهارات من الصفوف السابقة. ما في علامات ولا نجاح أو رسوب، الهدف نعرف شو بنراجع سوا.'),
        findsOneWidget);
    expect(find.text('العلوم والحياة'), findsOneWidget);
    expect(find.text('اللغة العربية'), findsOneWidget);
    expect(find.text('حوالي 5 دقائق'), findsOneWidget);
    expect(find.text('حوالي 3 دقائق'), findsOneWidget);
    expect(find.text('ابدأ'), findsOneWidget);
    expect(find.text('لاحقاً'), findsOneWidget);
  });

  testWidgets('onboarding: intro, questions, divider, result and then the shell',
      (tester) async {
    await open(tester, DiagnosticEntry.onboarding);
    await tapText(tester, GapFillingStrings.start);

    expect(find.text(GapFillingStrings.next), findsOneWidget);
    expect(tester.widget<FilledButton>(find.ancestor(
            of: find.text(GapFillingStrings.next),
            matching: find.byType(FilledButton))).onPressed,
        isNull);

    await answerDiagnostic(tester, questions,
        how: 'right',
        nextLabel: GapFillingStrings.next,
        skipLabel: GapFillingStrings.dontKnow);
    expect(find.text(GapFillingStrings.correct), findsNothing);

    await answerAll(tester, 'right', limit: 9);
    expect(find.text(GapFillingStrings.dividerLead), findsOneWidget);
    expect(find.text('اللغة العربية'), findsOneWidget);
    await answerAll(tester, 'right');

    expect(find.text(GapFillingStrings.resultTitle), findsOneWidget);
    expect(find.text(GapFillingStrings.strongSkills), findsWidgets);
    expect(find.text(GapFillingStrings.nothingToReview), findsWidgets);

    await tapText(tester, GapFillingStrings.startStudy);
    expect(find.text(shellMarker), findsOneWidget);
    expect(Get.currentRoute, AppRoutes.shell);
    expect(Get.key.currentState!.canPop(), isFalse);
  });

  testWidgets('a student who does not know sees the skills to review', (tester) async {
    await open(tester, DiagnosticEntry.onboarding);
    await tapText(tester, GapFillingStrings.start);
    await answerAll(tester, 'skip');
    expect(find.text(GapFillingStrings.pathTitle), findsWidgets);
    expect(find.text('الشحنات الكهربائية'), findsOneWidget);
    expect(find.text('من الصف الثامن'), findsWidgets);
    expect(find.text(GapFillingStrings.reviewNow), findsWidgets);
    expect(find.text(GapFillingStrings.strongSkills), findsNothing);
  });

  testWidgets('later skips the diagnostic and goes to the shell', (tester) async {
    await open(tester, DiagnosticEntry.onboarding);
    await tapText(tester, GapFillingStrings.later);
    expect(Get.currentRoute, AppRoutes.shell);
    expect(Get.key.currentState!.canPop(), isFalse);
    final attempts = await tester.runAsync(() => h.user.select(h.user.diagnosticAttempts).get());
    expect(attempts, isEmpty);
  });

  testWidgets('Back during the diagnostic from onboarding leaves to the shell',
      (tester) async {
    await open(tester, DiagnosticEntry.onboarding);
    await tapText(tester, GapFillingStrings.start);
    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(Get.currentRoute, AppRoutes.shell);
    expect(Get.key.currentState!.canPop(), isFalse);
  });

  testWidgets('an interrupted diagnostic resumes at the next unanswered question',
      (tester) async {
    await open(tester, DiagnosticEntry.onboarding);
    await tapText(tester, GapFillingStrings.start);
    await answerAll(tester, 'right', limit: 3);
    final resumeAt = visibleQuestion(questions).id;
    await tester.binding.handlePopRoute();
    await settle(tester);

    Get.toNamed(AppRoutes.diagnostic,
        arguments: const DiagnosticArgs(entry: DiagnosticEntry.profile));
    await settle(tester);
    await tapText(tester, GapFillingStrings.start);
    expect(visibleQuestion(questions).id, resumeAt);
  });

  testWidgets('profile: finishing returns to the previous screen and replaces the scores',
      (tester) async {
    await open(tester, DiagnosticEntry.profile);
    await tapText(tester, GapFillingStrings.start);
    await answerAll(tester, 'skip');
    await tapText(tester, GapFillingStrings.startStudy);
    expect(Get.currentRoute, hostRoute);
    var mastery = (await tester.runAsync(() => h.user.select(h.user.skillMastery).get()))!;
    expect(mastery.length, 8);
    expect(mastery.every((m) => m.score == 0), isTrue);

    Get.toNamed(AppRoutes.diagnostic,
        arguments: const DiagnosticArgs(entry: DiagnosticEntry.profile));
    await settle(tester);
    await tapText(tester, GapFillingStrings.start);
    await answerAll(tester, 'right');
    await tapText(tester, GapFillingStrings.startStudy);
    mastery = (await tester.runAsync(() => h.user.select(h.user.skillMastery).get()))!;
    expect(mastery.length, 8);
    expect(mastery.every((m) => m.score == 100), isTrue);
  });

  testWidgets('the dark theme shows the intro too', (tester) async {
    await open(tester, DiagnosticEntry.onboarding, theme: AppTheme.dark);
    expect(find.text(GapFillingStrings.introTitle), findsOneWidget);
  });
}
