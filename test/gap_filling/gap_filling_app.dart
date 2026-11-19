import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/services/database_service.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/gap_filling/domain/entities/diagnostic_question.dart';
import 'package:mualimi/features/gap_filling/presentation/bindings/diagnostic_binding.dart';
import 'package:mualimi/features/gap_filling/presentation/bindings/skill_review_binding.dart';
import 'package:mualimi/features/gap_filling/presentation/pages/diagnostic_page.dart';
import 'package:mualimi/features/gap_filling/presentation/pages/skill_review_page.dart';

import 'gap_filling_harness.dart';

const hostRoute = '/host';
const shellMarker = 'shell-page';

/// Runs the gap-filling routes over the seeded in-memory databases, with
/// [host] as the page that opens them.
Future<void> pumpGapFillingApp(
  WidgetTester tester,
  GapFillingHarness h, {
  Widget host = const SizedBox.shrink(),
  ThemeData? theme,
  double textScale = 1,
}) async {
  Get.put<DatabaseService>(h.databases);
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(GetMaterialApp(
    theme: theme ?? AppTheme.light,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
      child: Directionality(textDirection: TextDirection.rtl, child: child!),
    ),
    initialRoute: hostRoute,
    getPages: [
      GetPage(
          name: hostRoute,
          page: () => Scaffold(body: SingleChildScrollView(child: host))),
      GetPage(
          name: AppRoutes.shell,
          page: () => const Scaffold(body: Text(shellMarker))),
      GetPage(
          name: AppRoutes.diagnostic,
          page: DiagnosticPage.new,
          binding: DiagnosticBinding()),
      GetPage(
          name: AppRoutes.skillReview,
          page: SkillReviewPage.new,
          binding: SkillReviewBinding()),
    ],
  ));
  await settle(tester);
}

/// Lets database futures complete in real time, then settles animations.
Future<void> settle(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
  await tester.pumpAndSettle();
}

Future<void> tapText(WidgetTester tester, String text) async {
  final target = find.text(text);
  await tester.ensureVisible(target);
  await tester.tap(target);
  await settle(tester);
}

/// The question on screen, found by its prompt among [questions].
DiagnosticQuestion visibleQuestion(List<DiagnosticQuestion> questions) =>
    questions.firstWhere((q) => find.text(q.prompt).evaluate().isNotEmpty);

/// Answers the diagnostic question on screen: the right choice, the first
/// choice, or "I do not know". Taps "next" unless it skipped.
Future<void> answerDiagnostic(
  WidgetTester tester,
  List<DiagnosticQuestion> questions, {
  required String how,
  required String nextLabel,
  required String skipLabel,
}) async {
  final q = visibleQuestion(questions);
  if (how == 'skip') return tapText(tester, skipLabel);
  final index = how == 'right' ? q.answerIndex : 0;
  await tapText(tester, q.choices[index]);
  await tapText(tester, nextLabel);
}
