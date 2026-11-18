import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/constants/app_colors.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/services/settings_service.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/routes/tutor_args.dart';
import 'package:mualimi/features/lesson/data/repositories/reading_preferences_repository_impl.dart';
import 'package:mualimi/features/lesson/domain/repositories/reading_preferences_repository.dart';
import 'package:mualimi/features/lesson/presentation/controllers/viewer_controller.dart';
import 'package:mualimi/features/lesson/presentation/pages/viewer_page.dart';
import 'package:mualimi/features/lesson/presentation/widgets/viewer_footer_button.dart';
import 'package:mualimi/features/lesson/presentation/widgets/viewer_strings.dart';

import 'viewer_fakes.dart';

const _designSize = Size(390, 844);

Object? _tutorArguments;

Future<ViewerController> _pump(
  WidgetTester tester,
  FakeViewerLessonRepository lessons, {
  ReadingPreferencesRepository? preferences,
  SettingsService? settings,
  bool subjectTutorEnabled = true,
  ThemeData? theme,
  double textScale = 1,
}) async {
  final controller = Get.put(viewerController(
    lessons,
    preferences: preferences,
    subjectTutorEnabled: subjectTutorEnabled,
  ));
  tester.view.physicalSize = _designSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  _tutorArguments = null;
  await tester.pumpWidget(GetMaterialApp(
    theme: theme ?? AppTheme.light,
    builder: (context, child) {
      Widget scaled(double scale) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
            child: Directionality(textDirection: TextDirection.rtl, child: child!),
          );
      return settings == null ? scaled(textScale) : Obx(() => scaled(settings.fontScale.value));
    },
    initialRoute: AppRoutes.viewerOf(viewerLessonId),
    getPages: [
      GetPage(name: AppRoutes.viewer, page: () => const ViewerPage()),
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
  return controller;
}

ViewerFooterButton _footerButton(WidgetTester tester, String label) => tester.widget(
    find.ancestor(of: find.text(label), matching: find.byType(ViewerFooterButton)));

Future<void> _realWait(WidgetTester tester) =>
    tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));

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

  testWidgets('opens at the saved section with title, counter and tabs', (tester) async {
    await _pump(tester, FakeViewerLessonRepository(lastSection: 1));
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
    await _pump(tester, lessons);
    await tester.tap(find.text(ViewerStrings.next));
    await tester.pumpAndSettle();
    expect(find.text(ViewerStrings.sectionCounter(4, 4)), findsOneWidget);
    expect(_footerButton(tester, ViewerStrings.next).onPressed, isNull);
    await tester.tap(find.text(ViewerStrings.previous));
    await tester.pumpAndSettle();
    expect(find.text('Section 3'), findsOneWidget);
    expect(lessons.saved, [(viewerLessonId, 3), (viewerLessonId, 2)]);
  });

  testWidgets('a single-section lesson disables previous and next', (tester) async {
    await _pump(tester, FakeViewerLessonRepository(lesson: viewerLesson(sections: 1)));
    expect(_footerButton(tester, ViewerStrings.previous).onPressed, isNull);
    expect(_footerButton(tester, ViewerStrings.next).onPressed, isNull);
    expect(find.text(ViewerStrings.sectionCounter(1, 1)), findsOneWidget);
  });

  testWidgets('an empty lesson shows the empty state without footer or counter', (tester) async {
    await _pump(tester, FakeViewerLessonRepository(lesson: viewerLesson(sections: 0)));
    expect(find.text(ViewerStrings.empty), findsOneWidget);
    expect(find.text(ViewerStrings.next), findsNothing);
    expect(find.textContaining(ViewerStrings.sectionWord), findsNothing);
  });

  testWidgets('a failed load offers retry', (tester) async {
    final lessons = FakeViewerLessonRepository(fails: true);
    await _pump(tester, lessons);
    expect(find.text(ViewerStrings.loadFailed), findsOneWidget);
    lessons.fails = false;
    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();
    expect(find.text('Section 1'), findsOneWidget);
  });

  testWidgets('other tabs keep their placeholder and hide the footer', (tester) async {
    await _pump(tester, FakeViewerLessonRepository());
    await tester.tap(find.text(ViewerStrings.pdfTab));
    await tester.pumpAndSettle();
    expect(find.text(ViewerStrings.next), findsNothing);
    expect(find.byTooltip(ViewerStrings.fontSize), findsNothing);
  });

  testWidgets('explain opens the tutor with the subject and lesson', (tester) async {
    await _pump(tester, FakeViewerLessonRepository());
    await tester.tap(find.text(ViewerStrings.explainSection));
    await tester.pumpAndSettle();
    expect(_tutorArguments, const TutorArgs(subjectId: viewerSubjectId, lessonId: viewerLessonId));
  });

  for (final (lesson, subject) in [(false, true), (true, false)]) {
    testWidgets('explain is disabled when lesson=$lesson subject=$subject', (tester) async {
      await _pump(
        tester,
        FakeViewerLessonRepository(lesson: viewerLesson(tutorEnabled: lesson)),
        subjectTutorEnabled: subject,
      );
      expect(_footerButton(tester, ViewerStrings.explainSection).onPressed, isNull);
      await tester.tap(find.text(ViewerStrings.explainSection));
      await tester.pumpAndSettle();
      expect(_tutorArguments, isNull);
    });
  }

  testWidgets('the Aa button enlarges the text and the size persists', (tester) async {
    final dir = (await tester.runAsync(() => Directory.systemTemp.createTemp('viewer')))!;
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/settings.json');
    final settings = (await tester.runAsync(() => SettingsService(file).init()))!;
    await _pump(
      tester,
      FakeViewerLessonRepository(),
      preferences: ReadingPreferencesRepositoryImpl(settings),
      settings: settings,
    );
    final before = tester.getSize(find.text('Body 1')).height;
    await tester.tap(find.byTooltip(ViewerStrings.fontSize));
    await tester.pumpAndSettle();
    await _realWait(tester);
    final paragraph = tester.renderObject<RenderParagraph>(find.text('Body 1'));
    expect(paragraph.textScaler, const TextScaler.linear(1.15));
    expect(tester.getSize(find.text('Body 1')).height, greaterThan(before));
    final reloaded = (await tester.runAsync(() => SettingsService(file).init()))!;
    expect(reloaded.fontScale.value, 1.15);
  });

  final longBody = List.filled(80, 'نص طويل للشرح').join(' ');
  for (final (name, theme, colors) in [
    ('light', AppTheme.light, AppColors.light),
    ('dark', AppTheme.dark, AppColors.dark),
  ]) {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets('$name at text scale $scale lays out a long body without overflow',
          (tester) async {
        await _pump(
          tester,
          FakeViewerLessonRepository(lesson: viewerLesson(body: longBody), lastSection: 1),
          theme: theme,
          textScale: scale,
        );
        expect(tester.takeException(), isNull);
        expect(find.text(ViewerStrings.explainSection), findsOneWidget);
        final heading = tester.widget<Text>(find.text('Section 2'));
        expect(heading.style?.color, colors.primary);
        await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -2000));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
