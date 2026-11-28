import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/constants/app_colors.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/content_manager/presentation/constants/grade_ordinals.dart';
import 'package:mualimi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:mualimi/features/onboarding/domain/usecases/save_grade_usecase.dart';
import 'package:mualimi/features/onboarding/presentation/controllers/grade_controller.dart';
import 'package:mualimi/features/onboarding/presentation/pages/grade_page.dart';
import 'package:mualimi/features/onboarding/presentation/widgets/grade_strings.dart';
import 'package:mualimi/features/onboarding/presentation/widgets/grade_tile.dart';

const _designSize = Size(390, 844);
const _startRoute = '/start';
const _downloadStub = Key('download-stub');

class _FakeOnboardingRepository implements OnboardingRepository {
  int? savedGrade;

  @override
  bool get isOnboardingDone => false;

  @override
  bool get hasGrade => false;

  @override
  Future<void> saveStudentName(String name) async {}

  @override
  Future<void> saveGrade(int grade) async => savedGrade = grade;
}

Future<_FakeOnboardingRepository> _pumpGrade(
  WidgetTester tester,
  ThemeData theme, {
  String? name = 'سلمى',
  double textScale = 1,
}) async {
  tester.view.physicalSize = _designSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  addTearDown(Get.reset);
  final repository = _FakeOnboardingRepository();
  await tester.pumpWidget(GetMaterialApp(
    theme: theme,
    locale: const Locale('ar'),
    initialRoute: _startRoute,
    getPages: [
      GetPage(name: _startRoute, page: () => const Scaffold()),
      GetPage(
        name: AppRoutes.grade,
        page: GradePage.new,
        binding: BindingsBuilder(() {
          Get.put(GradeController(SaveGradeUseCase(repository)));
        }),
      ),
      GetPage(name: AppRoutes.download, page: () => const Scaffold(key: _downloadStub)),
    ],
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
      child: Directionality(textDirection: TextDirection.rtl, child: child!),
    ),
  ));
  Get.toNamed<void>(AppRoutes.grade, arguments: name);
  await tester.pumpAndSettle();
  return repository;
}

FilledButton _button(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byWidgetPredicate((widget) => widget is FilledButton));

void main() {
  final nine = GradeOrdinals.of(9);

  for (final (mode, theme, colors) in [
    ('light', AppTheme.light, AppColors.light),
    ('dark', AppTheme.dark, AppColors.dark),
  ]) {
    group('GradePage ($mode)', () {
      testWidgets('shows every text of the screen', (tester) async {
        await _pumpGrade(tester, theme);
        for (final text in [
          AppStrings.grade,
          GradeStrings.title('سلمى'),
          GradeStrings.subtitle,
          GradeStrings.step,
          AppStrings.download,
        ]) {
          expect(find.text(text), findsOneWidget, reason: text);
        }
        for (var grade = 1; grade <= 12; grade++) {
          expect(find.text(GradeOrdinals.of(grade)), findsOneWidget);
        }
        expect(find.text(AppStrings.gradePrefix), findsNWidgets(12));
        expect(find.text(AppStrings.comingSoon), findsNWidgets(11));
      });

      testWidgets('without a name the title has no vocative', (tester) async {
        await _pumpGrade(tester, theme, name: null);
        expect(find.text(GradeStrings.title('')), findsOneWidget);
      });

      testWidgets('starts with the button disabled and no grade selected', (tester) async {
        await _pumpGrade(tester, theme);
        expect(_button(tester).onPressed, isNull);
        expect(find.text(AppStrings.download), findsOneWidget);
      });

      testWidgets('selecting grade 9 enables the button and names the grade', (tester) async {
        await _pumpGrade(tester, theme);
        await tester.tap(find.text(nine));
        await tester.pump();
        expect(_button(tester).onPressed, isNotNull);
        expect(find.text(GradeStrings.downloadLabel(9)), findsOneWidget);
        final tile = tester.widget<Material>(find
            .descendant(
                of: find.widgetWithText(GradeTile, nine), matching: find.byType(Material))
            .first);
        expect(tile.color, colors.tint);
      });

      testWidgets('an unavailable grade cannot be selected', (tester) async {
        await _pumpGrade(tester, theme);
        await tester.tap(find.text(GradeOrdinals.of(10)));
        await tester.pump();
        expect(Get.find<GradeController>().selected.value, isNull);
        expect(_button(tester).onPressed, isNull);

        await tester.tap(find.text(nine));
        await tester.tap(find.text(GradeOrdinals.of(1)));
        await tester.pump();
        expect(Get.find<GradeController>().selected.value, 9);
      });

      testWidgets('download saves the grade and opens the download route', (tester) async {
        final repository = await _pumpGrade(tester, theme);
        await tester.tap(find.text(nine));
        await tester.pump();
        await tester.tap(find.text(GradeStrings.downloadLabel(9)));
        await tester.pumpAndSettle();
        expect(repository.savedGrade, 9);
        expect(Get.currentRoute, AppRoutes.download);
        expect(find.byKey(_downloadStub), findsOneWidget);
      });

      for (final scale in [1.0, 1.3, 2.0]) {
        testWidgets('lays out without overflow at text scale $scale', (tester) async {
          await _pumpGrade(tester, theme, textScale: scale);
          await tester.ensureVisible(find.text(nine));
          await tester.pumpAndSettle();
          await tester.tap(find.text(nine));
          await tester.pump();
          expect(tester.takeException(), isNull);
          final button = tester.getRect(find.text(GradeStrings.downloadLabel(9)));
          expect(button.bottom, lessThanOrEqualTo(_designSize.height));
          expect(button.top, greaterThanOrEqualTo(0));
        });
      }
    });
  }
}
