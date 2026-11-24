import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/core/widgets/state_message.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/routes/tutor_args.dart';
import 'package:mualimi/features/lesson/domain/entities/key_term.dart';
import 'package:mualimi/features/lesson/presentation/pages/lesson_page.dart';
import 'package:mualimi/features/lesson/presentation/widgets/lesson_hub_strings.dart';
import 'package:mualimi/features/lesson/presentation/widgets/lesson_key_term_card.dart';
import 'package:mualimi/features/lesson/presentation/widgets/viewer_strings.dart';

import 'lesson_hub_fakes.dart';

const _designSize = Size(390, 844);

final _opened = <String>[];
Object? _tutorArguments;

Future<void> _pump(
  WidgetTester tester,
  FakeHubLessonRepository lessons, {
  bool subjectTutorEnabled = true,
  ThemeData? theme,
  double textScale = 1,
}) async {
  Get.put(lessonController(lessons, subjectTutorEnabled: subjectTutorEnabled));
  tester.view.physicalSize = _designSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  _opened.clear();
  _tutorArguments = null;
  Widget record() {
    _opened.add(Get.currentRoute);
    return const Scaffold();
  }

  await tester.pumpWidget(GetMaterialApp(
    theme: theme ?? AppTheme.light,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
      child: Directionality(textDirection: TextDirection.rtl, child: child!),
    ),
    initialRoute: AppRoutes.lessonOf(hubLessonId),
    getPages: [
      GetPage(name: AppRoutes.lesson, page: () => const LessonPage()),
      GetPage(name: AppRoutes.viewer, page: record),
      GetPage(name: AppRoutes.keyTerms, page: record),
      GetPage(
        name: AppRoutes.tutor,
        page: () {
          _tutorArguments = Get.arguments;
          return const Scaffold();
        },
      ),
    ],
  ));
  await tester.pumpAndSettle();
}

Future<void> _tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Loads the bundled app font so widths match the device, not the test font.
Future<void> _loadAppFont() async {
  final loader = FontLoader('IBMPlexSansArabic');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    final bytes = File('assets/fonts/IBMPlexSansArabic-$weight.ttf').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

void main() {
  setUpAll(_loadAppFont);
  tearDown(Get.reset);

  testWidgets('header shows the title and subject · unit · printed pages', (tester) async {
    await _pump(tester, FakeHubLessonRepository());
    expect(find.text('Charging'), findsOneWidget);
    expect(find.text(LessonHubStrings.join(['Science', 'Unit 2', 'ص 44–49'])), findsOneWidget);
    expect(find.text(LessonHubStrings.join([LessonHubStrings.pdfLabel, 'ص 44–49'])),
        findsOneWidget);
    expect(find.text(LessonHubStrings.join(
            [LessonHubStrings.sectionsCount(4), LessonHubStrings.readyInApp])),
        findsOneWidget);
  });

  testWidgets('the PDF card opens the viewer on the pdf tab', (tester) async {
    await _pump(tester, FakeHubLessonRepository());
    await _tapAndSettle(tester, find.text(LessonHubStrings.pdfTitle));
    expect(_opened, [AppRoutes.viewerOf(hubLessonId, tab: 'pdf')]);
  });

  testWidgets('the explanation card opens the viewer on the explanation tab', (tester) async {
    await _pump(tester, FakeHubLessonRepository());
    await _tapAndSettle(tester, find.text(LessonHubStrings.explanationTitle));
    expect(_opened, [AppRoutes.viewerOf(hubLessonId, tab: 'explanation')]);
  });

  testWidgets('the PDF card still opens after returning from another page', (tester) async {
    await _pump(tester, FakeHubLessonRepository());
    for (final label in [LessonHubStrings.explanationTitle, 'Term 1']) {
      await _tapAndSettle(tester, find.text(label));
      Get.back<void>();
      await tester.pumpAndSettle();
    }
    await _tapAndSettle(tester, find.text(LessonHubStrings.pdfTitle));
    expect(_opened, [
      AppRoutes.viewerOf(hubLessonId, tab: 'explanation'),
      AppRoutes.keyTermsOf(hubLessonId),
      AppRoutes.viewerOf(hubLessonId, tab: 'pdf'),
    ]);
  });

  testWidgets('a lesson with no PDF, sections or key terms shows the empty state',
      (tester) async {
    await _pump(tester,
        FakeHubLessonRepository(lesson: hubLesson(pdfFile: null, sections: 0), terms: const []));
    expect(find.text(LessonHubStrings.emptyTitle), findsOneWidget);
    expect(find.byType(StateMessage), findsOneWidget);
    expect(find.text(LessonHubStrings.filesTitle), findsNothing);
    expect(find.text(LessonHubStrings.askTutorTitle), findsOneWidget);
  });

  for (final (name, repository) in [
    ('a PDF', () => FakeHubLessonRepository(lesson: hubLesson(sections: 0), terms: const [])),
    ('sections', () => FakeHubLessonRepository(lesson: hubLesson(pdfFile: null), terms: const [])),
    ('key terms', () => FakeHubLessonRepository(lesson: hubLesson(pdfFile: null, sections: 0))),
  ]) {
    testWidgets('a lesson with only $name hides the empty state', (tester) async {
      await _pump(tester, repository());
      expect(find.text(LessonHubStrings.emptyTitle), findsNothing);
      expect(find.byType(StateMessage), findsNothing);
    });
  }

  for (final file in [null, '']) {
    testWidgets('a lesson without a PDF (${file ?? 'null'}) hides the PDF card', (tester) async {
      await _pump(tester, FakeHubLessonRepository(lesson: hubLesson(pdfFile: file)));
      expect(find.text(LessonHubStrings.pdfTitle), findsNothing);
      expect(find.text(LessonHubStrings.explanationTitle), findsOneWidget);
    });
  }

  testWidgets('a lesson with neither PDF nor sections hides the files section', (tester) async {
    await _pump(tester, FakeHubLessonRepository(lesson: hubLesson(pdfFile: null, sections: 0)));
    expect(find.text(LessonHubStrings.filesTitle), findsNothing);
    expect(find.text(LessonHubStrings.keyTermsTitle), findsOneWidget);
  });

  testWidgets('no key terms hides the key terms section', (tester) async {
    await _pump(tester, FakeHubLessonRepository(terms: const []));
    expect(find.text(LessonHubStrings.keyTermsTitle), findsNothing);
    expect(find.byType(LessonKeyTermCard), findsNothing);
  });

  testWidgets('one key term shows a single card that opens key terms', (tester) async {
    await _pump(tester, FakeHubLessonRepository(terms: hubTerms(1)));
    expect(find.text(LessonHubStrings.cardsCount(1)), findsOneWidget);
    expect(find.byType(LessonKeyTermCard), findsOneWidget);
    await _tapAndSettle(tester, find.text('Term 1'));
    expect(_opened, [AppRoutes.keyTermsOf(hubLessonId)]);
  });

  testWidgets('many key terms scroll sideways and each opens key terms', (tester) async {
    await _pump(tester, FakeHubLessonRepository(terms: hubTerms(5)));
    expect(find.text(LessonHubStrings.cardsCount(5)), findsOneWidget);
    expect(find.text('Term 1'), findsOneWidget);
    expect(find.text('Meaning 1'), findsOneWidget);
    await tester.dragUntilVisible(
        find.text('Term 5'), find.byType(LessonKeyTermCard).first, const Offset(300, 0));
    await _tapAndSettle(tester, find.text('Term 5'));
    expect(_opened, [AppRoutes.keyTermsOf(hubLessonId)]);
  });

  testWidgets('the ask-tutor bar opens the tutor with the subject and lesson', (tester) async {
    await _pump(tester, FakeHubLessonRepository());
    expect(find.text(LessonHubStrings.askTutorSubtitle), findsOneWidget);
    expect(find.text(LessonHubStrings.tutorUnavailableBody), findsNothing);
    await _tapAndSettle(tester, find.text(LessonHubStrings.askTutorTitle));
    expect(_tutorArguments, const TutorArgs(subjectId: hubSubjectId, lessonId: hubLessonId));
  });

  for (final (lesson, subject) in [(false, true), (true, false)]) {
    testWidgets('the unavailable card replaces the bar when lesson=$lesson subject=$subject',
        (tester) async {
      await _pump(
        tester,
        FakeHubLessonRepository(lesson: hubLesson(tutorEnabled: lesson)),
        subjectTutorEnabled: subject,
      );
      expect(find.text(LessonHubStrings.askTutorTitle), findsNothing);
      expect(find.text(LessonHubStrings.tutorUnavailableTitle), findsOneWidget);
      expect(find.text(LessonHubStrings.tutorUnavailableBody), findsOneWidget);
      expect(find.text(LessonHubStrings.comingSoon), findsOneWidget);
      await _tapAndSettle(tester, find.text(LessonHubStrings.tutorUnavailableTitle));
      expect(_tutorArguments, isNull);
    });
  }

  testWidgets('a failed load offers retry', (tester) async {
    final lessons = FakeHubLessonRepository(fails: true);
    await _pump(tester, lessons);
    expect(find.text(ViewerStrings.loadFailed), findsOneWidget);
    lessons.fails = false;
    await _tapAndSettle(tester, find.text(AppStrings.retry));
    expect(find.text('Charging'), findsOneWidget);
    expect(find.text(LessonHubStrings.filesTitle), findsOneWidget);
  });

  final longText = List.filled(12, 'طرق الشحن الكهربائي').join(' ');
  for (final (name, theme) in [('light', AppTheme.light), ('dark', AppTheme.dark)]) {
    for (final scale in [1.0, 1.3, 2.0]) {
      for (final tutor in [true, false]) {
        testWidgets('$name at text scale $scale (tutor $tutor) lays out without overflow',
            (tester) async {
          await _pump(
            tester,
            FakeHubLessonRepository(
              lesson: hubLesson(title: longText, tutorEnabled: tutor),
              terms: [KeyTerm(term: longText, definition: longText), ...hubTerms(3)],
            ),
            theme: theme,
            textScale: scale,
          );
          expect(tester.takeException(), isNull);
          await tester.drag(find.byType(ListView).first, const Offset(0, -2000));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
