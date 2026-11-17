import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/core/utils/byte_formatter.dart';
import 'package:mualimi/features/profile/domain/entities/app_theme_mode.dart';
import 'package:mualimi/features/profile/domain/entities/pack_update_check.dart';
import 'package:mualimi/features/profile/presentation/pages/profile_page.dart';
import 'package:mualimi/features/profile/presentation/widgets/edit_name_sheet.dart';
import 'package:mualimi/features/profile/presentation/widgets/profile_strings.dart';

import 'profile_fakes.dart';

const _designSize = Size(390, 844);

Future<ProfileFixture> _pump(
  WidgetTester tester, {
  ThemeData? theme,
  double textScale = 1,
  PackUpdateCheck updateResult = PackUpdateCheck.upToDate,
}) async {
  final fixture = ProfileFixture(updateResult: updateResult);
  Get.put(fixture.controller());
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
      GetPage(name: '/', page: () => const ProfilePage()),
      GetPage(name: AppRoutes.download, page: () => const Text('download')),
    ],
  ));
  await tester.pumpAndSettle();
  return fixture;
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder, 100);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  tearDown(Get.reset);

  testWidgets('shows every kept element with its value', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester);
    expect(find.bySemanticsLabel(ProfileStrings.editName), findsOneWidget);
    expect(find.text('أ'), findsOneWidget);
    expect(find.text('أحمد'), findsOneWidget);
    expect(find.text('الصف التاسع · ${ProfileStrings.noAccount}'), findsOneWidget);
    expect(find.text(ProfileStrings.storageTitle), findsOneWidget);
    expect(find.text(ByteFormatter.format(40 << 20)), findsOneWidget);
    expect(find.text('40.0 م.ب'), findsOneWidget);
    for (final text in [
      ProfileStrings.packSegment,
      ProfileStrings.pdfSegment,
      ProfileStrings.appearance,
      ProfileStrings.themeLight,
      ProfileStrings.themeDark,
      ProfileStrings.themeSystem,
      ProfileStrings.study,
      ProfileStrings.grade,
      'التاسع',
      ProfileStrings.change,
      ProfileStrings.fontSize,
      ProfileStrings.fontMedium,
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
    for (final text in [
      ProfileStrings.downloads,
      'رزمة الصف التاسع',
      'الإصدار 3',
      ProfileStrings.checkUpdate,
      ProfileStrings.aboutSection,
      ProfileStrings.about,
      ProfileStrings.aboutSubtitle,
    ]) {
      await tester.scrollUntilVisible(find.text(text), 100);
      expect(find.text(text), findsOneWidget, reason: text);
    }
    semantics.dispose();
  });

  testWidgets('the model and PDF rows are gone', (tester) async {
    await _pump(tester);
    await tester.drag(find.byType(ListView), const Offset(0, -4000));
    await tester.pumpAndSettle();
    expect(find.textContaining('Gemma'), findsNothing);
    expect(find.text('حذف'), findsNothing);
    expect(find.text(ProfileStrings.pdfSegment), findsOneWidget, reason: 'legend only');
  });

  testWidgets('edit button opens the name sheet', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester);
    await tester.tap(find.bySemanticsLabel(ProfileStrings.editName));
    await tester.pumpAndSettle();
    expect(find.byType(EditNameSheet), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('theme options save the chosen mode', (tester) async {
    final fixture = await _pump(tester);
    await tester.tap(find.text(ProfileStrings.themeDark));
    await tester.pumpAndSettle();
    expect(fixture.profiles.profile.themeMode, AppThemeMode.dark);
    await tester.tap(find.text(ProfileStrings.themeSystem));
    await tester.pumpAndSettle();
    expect(fixture.profiles.profile.themeMode, AppThemeMode.system);
  });

  testWidgets('change grade opens the sheet, a grade goes to the download route',
      (tester) async {
    final fixture = await _pump(tester);
    await tester.tap(find.text(ProfileStrings.change));
    await tester.pumpAndSettle();
    await tester.tap(find.text('${AppStrings.gradePrefix} 9'));
    await tester.pumpAndSettle();
    expect(fixture.profiles.profile.grade, 9);
    expect(find.text('download'), findsOneWidget);
  });

  testWidgets('font row cycles the global scale and its label', (tester) async {
    final fixture = await _pump(tester);
    await tester.tap(find.text(ProfileStrings.fontSize));
    await tester.pumpAndSettle();
    expect(fixture.profiles.profile.fontScale, 1.15);
    expect(find.text(ProfileStrings.fontLarge), findsOneWidget);
  });

  testWidgets('update check marks the pack current only when online and current',
      (tester) async {
    final fixture = await _pump(tester);
    await _tapVisible(tester, find.text(ProfileStrings.checkUpdate));
    expect(fixture.updates.checkedGrades, [9]);
    expect(find.text('الإصدار 3 · محدّثة'), findsOneWidget);
  });

  testWidgets('update check offline keeps only the version', (tester) async {
    await _pump(tester, updateResult: PackUpdateCheck.unavailable);
    await _tapVisible(tester, find.text(ProfileStrings.checkUpdate));
    expect(find.text('الإصدار 3'), findsOneWidget);
    expect(find.textContaining(ProfileStrings.upToDate), findsNothing);
  });

  testWidgets('update check with a newer pack opens the update sheet', (tester) async {
    final fixture = await _pump(tester, updateResult: PackUpdateCheck.updateAvailable);
    await _tapVisible(tester, find.text(ProfileStrings.checkUpdate));
    expect(fixture.updateSheetOpens, 1);
  });

  testWidgets('about row does nothing yet', (tester) async {
    await _pump(tester);
    await _tapVisible(tester, find.text(ProfileStrings.about));
    expect(find.byType(BottomSheet), findsNothing);
    expect(find.text('download'), findsNothing);
  });

  for (final (mode, theme) in [('light', AppTheme.light), ('dark', AppTheme.dark)]) {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets('$mode at text scale $scale lays out without overflow', (tester) async {
        await _pump(tester, theme: theme, textScale: scale);
        expect(tester.takeException(), isNull);
        await tester.drag(find.byType(ListView), const Offset(0, -4000));
        await tester.pumpAndSettle();
        expect(find.text(ProfileStrings.aboutSubtitle), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
