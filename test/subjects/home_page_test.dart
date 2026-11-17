import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/subjects/domain/entities/continue_lesson.dart';
import 'package:mualimi/features/subjects/domain/entities/student_summary.dart';
import 'package:mualimi/features/subjects/domain/entities/subject.dart';
import 'package:mualimi/features/subjects/domain/usecases/get_continue_lesson_usecase.dart';
import 'package:mualimi/features/subjects/domain/usecases/get_subjects_usecase.dart';
import 'package:mualimi/features/subjects/domain/usecases/watch_online_usecase.dart';
import 'package:mualimi/features/subjects/domain/usecases/watch_student_usecase.dart';
import 'package:mualimi/features/subjects/presentation/controllers/home_controller.dart';
import 'package:mualimi/features/subjects/presentation/pages/home_page.dart';
import 'package:mualimi/features/subjects/presentation/widgets/home_strings.dart';

import 'home_fakes.dart';

const _designSize = Size(390, 844);
const _student = StudentSummary(name: 'أحمد', grade: 9);

class _Home {
  late FakeStudentRepository student;
  late FakeNetworkStatusRepository network;
  late FakeContinueLessonRepository progress;

  Future<void> pump(
    WidgetTester tester, {
    ThemeData? theme,
    double textScale = 1,
    bool online = true,
    StudentSummary studentSummary = _student,
    ContinueLesson? lesson = homeContinueLesson,
    List<Subject> subjects = homeSubjects,
    DateTime? now,
  }) async {
    student = FakeStudentRepository(studentSummary);
    network = FakeNetworkStatusRepository(online: online);
    progress = FakeContinueLessonRepository(lesson);
    Get.put(HomeController(
      GetSubjectsUseCase(FakeSubjectsRepository(subjects)),
      GetContinueLessonUseCase(progress),
      WatchStudentUseCase(student),
      WatchOnlineUseCase(network),
      now: () => now ?? DateTime(2026, 11, 17, 18),
    ));
    tester.view.physicalSize = _designSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(GetMaterialApp(
      theme: theme ?? AppTheme.light,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
        child: Directionality(textDirection: TextDirection.rtl, child: child!),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: AppRoutes.subject, page: () => Text('subject ${Get.parameters['id']}')),
        GetPage(name: AppRoutes.lesson, page: () => Text('lesson ${Get.parameters['id']}')),
      ],
    ));
    await tester.pumpAndSettle();
  }
}

void main() {
  final home = _Home();
  tearDown(Get.reset);

  testWidgets('shows greeting, name and grade label', (tester) async {
    await home.pump(tester);
    expect(find.text(HomeStrings.eveningGreeting), findsOneWidget);
    expect(find.text('أحمد'), findsOneWidget);
    expect(find.text('الصف التاسع'), findsOneWidget);
  });

  testWidgets('greets by time of day', (tester) async {
    await home.pump(tester, now: DateTime(2026, 11, 17, 9));
    expect(find.text(HomeStrings.morningGreeting), findsOneWidget);
    expect(find.text(HomeStrings.eveningGreeting), findsNothing);
  });

  testWidgets('hides the grade chip until a grade is chosen, follows name edits', (tester) async {
    await home.pump(tester, studentSummary: const StudentSummary(name: 'أحمد', grade: null));
    expect(find.textContaining('الصف'), findsNothing);
    home.student.emit(const StudentSummary(name: 'سلمى', grade: 9));
    await tester.pumpAndSettle();
    expect(find.text('سلمى'), findsOneWidget);
    expect(find.text('الصف التاسع'), findsOneWidget);
  });

  testWidgets('tutor chip follows connectivity', (tester) async {
    await home.pump(tester, online: false);
    expect(find.text(HomeStrings.offlineReady), findsOneWidget);
    expect(find.text(HomeStrings.tutorOffline), findsOneWidget);
    expect(find.text(HomeStrings.tutorOnline), findsNothing);
    home.network.emit(true);
    await tester.pumpAndSettle();
    expect(find.text(HomeStrings.tutorOnline), findsOneWidget);
    expect(find.text(HomeStrings.tutorOffline), findsNothing);
  });

  testWidgets('lists subjects with count and tutor badges', (tester) async {
    await home.pump(tester, lesson: null);
    expect(find.text(HomeStrings.yourSubjects), findsOneWidget);
    expect(find.text('8 مواد'), findsOneWidget);
    for (final subject in homeSubjects) {
      await tester.scrollUntilVisible(find.text(subject.name), 100);
      expect(find.text(subject.name), findsOneWidget);
    }
    expect(find.text(HomeStrings.tutorSoon), findsOneWidget);
    await tester.scrollUntilVisible(find.text(HomeStrings.mathGlyph), -100);
    expect(find.text(HomeStrings.arabicGlyph), findsOneWidget);
    expect(find.text(HomeStrings.englishGlyph), findsOneWidget);
  });

  testWidgets('continue card shows the last lesson', (tester) async {
    await home.pump(tester);
    expect(find.text(HomeStrings.continueLabel), findsOneWidget);
    expect(find.text('طرق الشحن الكهربائي'), findsOneWidget);
    expect(find.text('العلوم والحياة · الكهرباء الساكنة'), findsOneWidget);
  });

  testWidgets('continue card is hidden without progress', (tester) async {
    await home.pump(tester, lesson: null);
    expect(find.text(HomeStrings.continueLabel), findsNothing);
  });

  testWidgets('tapping a subject opens its route', (tester) async {
    await home.pump(tester, lesson: null);
    await tester.tap(find.text('الرياضيات'));
    await tester.pumpAndSettle();
    expect(find.text('subject math'), findsOneWidget);
  });

  testWidgets('tapping the continue card opens the lesson, back refreshes it', (tester) async {
    await home.pump(tester);
    await tester.tap(find.text(HomeStrings.continueLabel));
    await tester.pumpAndSettle();
    expect(find.text('lesson science-9-charging'), findsOneWidget);
    home.progress.lesson = null;
    Get.back<void>();
    await tester.pumpAndSettle();
    expect(find.text(HomeStrings.continueLabel), findsNothing);
  });

  for (final (mode, theme) in [('light', AppTheme.light), ('dark', AppTheme.dark)]) {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets('$mode at text scale $scale lays out without overflow', (tester) async {
        await home.pump(tester, theme: theme, textScale: scale, online: false);
        expect(tester.takeException(), isNull);
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -4000));
        await tester.pumpAndSettle();
        expect(find.text('التكنولوجيا'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
