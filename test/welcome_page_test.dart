import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/constants/app_colors.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:mualimi/features/onboarding/domain/usecases/save_student_name_usecase.dart';
import 'package:mualimi/features/onboarding/presentation/controllers/welcome_controller.dart';
import 'package:mualimi/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:mualimi/features/onboarding/presentation/widgets/welcome_header.dart';
import 'package:mualimi/features/onboarding/presentation/widgets/welcome_strings.dart';

const _designSize = Size(390, 844);
const _gradeStub = Key('grade-stub');

class _FakeOnboardingRepository implements OnboardingRepository {
  String? savedName;

  @override
  bool get isOnboardingDone => false;

  @override
  Future<bool> isPackInstalled() async => false;

  @override
  Future<void> saveStudentName(String name) async => savedName = name;

  @override
  Future<void> saveGrade(int grade) async {}
}

Future<_FakeOnboardingRepository> _pumpWelcome(
  WidgetTester tester,
  ThemeData theme, {
  double textScale = 1,
}) async {
  tester.view.physicalSize = _designSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  addTearDown(Get.reset);
  final repository = _FakeOnboardingRepository();
  Get.put(WelcomeController(SaveStudentNameUseCase(repository)));
  await tester.pumpWidget(GetMaterialApp(
    theme: theme,
    locale: const Locale('ar'),
    initialRoute: AppRoutes.welcome,
    getPages: [
      GetPage(name: AppRoutes.welcome, page: WelcomePage.new),
      GetPage(name: AppRoutes.grade, page: () => const Scaffold(key: _gradeStub)),
    ],
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
      child: Directionality(textDirection: TextDirection.rtl, child: child!),
    ),
  ));
  await tester.pumpAndSettle();
  return repository;
}

void main() {
  for (final (mode, theme, colors) in [
    ('light', AppTheme.light, AppColors.light),
    ('dark', AppTheme.dark, AppColors.dark),
  ]) {
    group('WelcomePage ($mode)', () {
      testWidgets('shows every text of the screen', (tester) async {
        await _pumpWelcome(tester, theme);
        for (final text in [
          WelcomeStrings.offlineChip,
          WelcomeStrings.title,
          WelcomeStrings.subtitle,
          WelcomeStrings.intro,
          WelcomeStrings.lessonsTitle,
          WelcomeStrings.lessonsDescription,
          WelcomeStrings.tutorTitle,
          WelcomeStrings.tutorDescription,
          WelcomeStrings.sourceTitle,
          WelcomeStrings.sourceDescription,
          WelcomeStrings.nameLabel,
          WelcomeStrings.privacyNote,
          WelcomeStrings.step,
          AppStrings.next,
        ]) {
          expect(find.text(text), findsOneWidget, reason: text);
        }
        expect(find.text('${AppStrings.appName}.', findRichText: true), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('header uses the theme hero color', (tester) async {
        await _pumpWelcome(tester, theme);
        final header = tester.widget<Container>(
            find.descendant(of: find.byType(WelcomeHeader), matching: find.byType(Container)).first);
        expect((header.decoration! as BoxDecoration).color, colors.hero);
      });

      testWidgets('next with a name saves it and opens the grade route', (tester) async {
        final repository = await _pumpWelcome(tester, theme);
        await tester.enterText(find.byType(TextField), '  سلمى ');
        await tester.tap(find.text(AppStrings.next));
        await tester.pumpAndSettle();
        expect(repository.savedName, 'سلمى');
        expect(Get.currentRoute, AppRoutes.grade);
        expect(Get.arguments, 'سلمى', reason: 'the grade title greets the student by name');
        expect(find.byKey(_gradeStub), findsOneWidget);
      });

      testWidgets('next with an empty name shows the error and stays', (tester) async {
        final repository = await _pumpWelcome(tester, theme);
        await tester.tap(find.text(AppStrings.next));
        await tester.pumpAndSettle();
        expect(find.text(AppStrings.studentNameInvalid), findsOneWidget);
        expect(repository.savedName, isNull);
        expect(Get.currentRoute, AppRoutes.welcome);
      });

      for (final scale in [1.0, 1.3, 2.0]) {
        testWidgets('lays out without overflow at text scale $scale', (tester) async {
          await _pumpWelcome(tester, theme, textScale: scale);
          expect(tester.takeException(), isNull);
          final button = tester.getRect(find.text(AppStrings.next));
          expect(button.bottom, lessThanOrEqualTo(_designSize.height));
          expect(button.top, greaterThanOrEqualTo(0));
        });
      }
    });
  }
}
