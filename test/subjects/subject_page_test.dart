import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/routes/tutor_args.dart';
import 'package:mualimi/features/subjects/presentation/widgets/subject_strings.dart';

import 'subject_fixtures.dart';

void main() {
  final page = SubjectHarness();
  tearDown(Get.reset);

  testWidgets('header shows name, grade and unit count', (tester) async {
    await page.pump(tester);
    expect(find.text('العلوم والحياة'), findsOneWidget);
    expect(find.text('الصف التاسع · 2 وحدات'), findsOneWidget);
    expect(find.byTooltip(SubjectStrings.back), findsOneWidget);
  });

  testWidgets('header shows only the unit count without a grade', (tester) async {
    await page.pump(tester, grade: null);
    expect(find.text('2 وحدات'), findsOneWidget);
  });

  testWidgets('ask the tutor opens the tutor route with the subject', (tester) async {
    await page.pump(tester);
    await tester.tap(find.byTooltip(SubjectStrings.askTutorAboutSubject));
    await tester.pumpAndSettle();
    expect(find.text('tutor'), findsOneWidget);
    expect(page.tutorArguments, const TutorArgs(subjectId: 'science'));
  });

  testWidgets('ask the tutor is hidden when the subject has no tutor', (tester) async {
    await page.pump(tester, subjectId: 'math');
    expect(find.text('الرياضيات'), findsOneWidget);
    expect(find.byTooltip(SubjectStrings.askTutorAboutSubject), findsNothing);
  });

  testWidgets('without progress the first unit is expanded', (tester) async {
    await page.pump(tester);
    expect(find.text('2 دروس'), findsOneWidget);
    expect(find.text('3 دروس'), findsOneWidget);
    expect(find.text('الخلية الحية'), findsOneWidget);
    expect(find.text('صفحات الكتاب 10–12'), findsOneWidget);
    expect(find.text('صفحات الكتاب 13'), findsOneWidget);
    expect(find.text('طرق الشحن الكهربائي'), findsNothing);
    expect(find.textContaining(SubjectStrings.lastOpened), findsNothing);
  });

  testWidgets('the unit with the last opened lesson is expanded and marked', (tester) async {
    await page.pump(tester, lastOpened: {'science': 'charging'});
    expect(find.text('الخلية الحية'), findsNothing);
    expect(find.text('صفحات الكتاب 40–43'), findsOneWidget);
    expect(find.text('صفحات الكتاب 44–49 · آخر درس فتحته'), findsOneWidget);
    expect(find.textContaining(SubjectStrings.lastOpened), findsOneWidget);
    expect(find.text('الكشّاف الكهربائي'), findsOneWidget);
  });

  testWidgets('a lesson without pages shows the marker alone', (tester) async {
    await page.pump(tester, lastOpened: {'science': 'electroscope'});
    expect(find.text(SubjectStrings.lastOpened), findsOneWidget);
  });

  testWidgets('tapping a unit toggles its lessons', (tester) async {
    await page.pump(tester);
    await tester.tap(find.text('الكهرباء الساكنة'));
    await tester.pumpAndSettle();
    expect(find.text('طرق الشحن الكهربائي'), findsOneWidget);
    expect(find.text('الخلية الحية'), findsOneWidget);
    await tester.tap(find.text('الخلية'));
    await tester.pumpAndSettle();
    expect(find.text('الخلية الحية'), findsNothing);
  });

  testWidgets('tapping a lesson opens it; back refreshes the marker', (tester) async {
    await page.pump(tester);
    await tester.tap(find.text('الخلية الحية'));
    await tester.pumpAndSettle();
    expect(find.text('lesson cell-1'), findsOneWidget);
    page.progress.lastOpenedBySubject = {'science': 'cell-1'};
    Get.back<void>();
    await tester.pumpAndSettle();
    expect(find.text('صفحات الكتاب 10–12 · آخر درس فتحته'), findsOneWidget);
  });

  testWidgets('a subject without lessons shows the empty state', (tester) async {
    await page.pump(tester, units: const {});
    expect(find.text(SubjectStrings.emptyTitle), findsOneWidget);
    expect(find.text('الصف التاسع · 0 وحدات'), findsOneWidget);
  });

  testWidgets('a failed load shows the failure state and retries', (tester) async {
    await page.pump(tester, failure: const DatabaseFailure('closed'));
    expect(find.text(SubjectStrings.failureTitle), findsOneWidget);
    expect(find.text(AppStrings.subject), findsOneWidget);
    expect(find.byTooltip(SubjectStrings.back), findsOneWidget);
    expect(find.text('الخلية'), findsNothing);

    page.subjects.failure = null;
    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();
    expect(find.text(SubjectStrings.failureTitle), findsNothing);
    expect(find.text('الخلية الحية'), findsOneWidget);
  });
}
