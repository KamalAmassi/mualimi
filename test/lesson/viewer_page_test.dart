import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/routes/tutor_args.dart';
import 'package:mualimi/features/lesson/presentation/widgets/viewer_footer_button.dart';
import 'package:mualimi/features/lesson/presentation/widgets/viewer_strings.dart';

import 'viewer_fakes.dart';
import 'viewer_page_harness.dart';

ViewerFooterButton _footerButton(WidgetTester tester, String label) => tester.widget(
    find.ancestor(of: find.text(label), matching: find.byType(ViewerFooterButton)));

void main() {
  setUpAll(loadAppFont);
  tearDown(Get.reset);

  testWidgets('opens at the saved section with title, counter and tabs', (tester) async {
    await pumpViewer(tester, FakeViewerLessonRepository(lastSection: 1));
    expect(find.text('Charging'), findsOneWidget);
    expect(find.text(ViewerStrings.sectionCounter(2, 4)), findsOneWidget);
    expect(find.text('Section 2'), findsOneWidget);
    expect(find.text('Body 2'), findsOneWidget);
    for (final label in [
      ViewerStrings.explanationTab,
      ViewerStrings.pdfTab,
      ViewerStrings.solutionsTab,
    ]) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('next and previous move, respect bounds and save progress', (tester) async {
    final lessons = FakeViewerLessonRepository(lastSection: 2);
    await pumpViewer(tester, lessons);
    await tester.tap(find.text(ViewerStrings.next));
    await tester.pumpAndSettle();
    expect(find.text(ViewerStrings.sectionCounter(4, 4)), findsOneWidget);
    expect(_footerButton(tester, ViewerStrings.next).onPressed, isNull);
    await tester.tap(find.text(ViewerStrings.previous));
    await tester.pumpAndSettle();
    expect(find.text('Section 3'), findsOneWidget);
    expect(lessons.saved, [(viewerLessonId, 2), (viewerLessonId, 3), (viewerLessonId, 2)]);
  });

  testWidgets('a single-section lesson disables previous and next', (tester) async {
    await pumpViewer(tester, FakeViewerLessonRepository(lesson: viewerLesson(sections: 1)));
    expect(_footerButton(tester, ViewerStrings.previous).onPressed, isNull);
    expect(_footerButton(tester, ViewerStrings.next).onPressed, isNull);
    expect(find.text(ViewerStrings.sectionCounter(1, 1)), findsOneWidget);
  });

  testWidgets('an empty lesson shows the empty state without footer or counter', (tester) async {
    await pumpViewer(tester, FakeViewerLessonRepository(lesson: viewerLesson(sections: 0)));
    expect(find.text(ViewerStrings.empty), findsOneWidget);
    expect(find.text(ViewerStrings.next), findsNothing);
    expect(find.textContaining(ViewerStrings.sectionWord), findsNothing);
  });

  testWidgets('a failed load offers retry', (tester) async {
    final lessons = FakeViewerLessonRepository(fails: true);
    await pumpViewer(tester, lessons);
    expect(find.text(ViewerStrings.loadFailed), findsOneWidget);
    lessons.fails = false;
    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();
    expect(find.text('Section 1'), findsOneWidget);
  });

  testWidgets('other tabs keep their placeholder and hide the footer', (tester) async {
    await pumpViewer(tester, FakeViewerLessonRepository());
    await tester.tap(find.text(ViewerStrings.pdfTab));
    await tester.pumpAndSettle();
    expect(find.text(ViewerStrings.next), findsNothing);
    expect(find.byTooltip(ViewerStrings.fontSize), findsNothing);
  });

  testWidgets('explain opens the tutor with the subject and lesson', (tester) async {
    await pumpViewer(tester, FakeViewerLessonRepository());
    await tester.tap(find.text(ViewerStrings.explainSection));
    await tester.pumpAndSettle();
    expect(tutorArguments, const TutorArgs(subjectId: viewerSubjectId, lessonId: viewerLessonId));
  });

  for (final (lesson, subject) in [(false, true), (true, false)]) {
    testWidgets('explain is disabled when lesson=$lesson subject=$subject', (tester) async {
      await pumpViewer(
        tester,
        FakeViewerLessonRepository(lesson: viewerLesson(tutorEnabled: lesson)),
        subjectTutorEnabled: subject,
      );
      expect(_footerButton(tester, ViewerStrings.explainSection).onPressed, isNull);
      await tester.tap(find.text(ViewerStrings.explainSection));
      await tester.pumpAndSettle();
      expect(tutorArguments, isNull);
    });
  }
}
