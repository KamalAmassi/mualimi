import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/features/profile/domain/entities/app_theme_mode.dart';
import 'package:mualimi/features/profile/domain/entities/profile.dart';
import 'package:mualimi/features/profile/presentation/widgets/about_sheet.dart';
import 'package:mualimi/features/profile/presentation/widgets/change_grade_sheet.dart';
import 'package:mualimi/features/profile/presentation/widgets/change_grade_tile.dart';
import 'package:mualimi/features/profile/presentation/widgets/edit_name_sheet.dart';
import 'package:mualimi/features/profile/presentation/widgets/profile_sheet_strings.dart';
import 'package:mualimi/features/profile/presentation/widgets/profile_strings.dart';

import 'profile_sheet_harness.dart';

ChangeGradeTile _tile(WidgetTester tester, int grade) => tester
    .widgetList<ChangeGradeTile>(find.byType(ChangeGradeTile))
    .firstWhere((tile) => tile.grade == grade);

FilledButton _footer(WidgetTester tester) =>
    tester.widget<FilledButton>(inSheet<ChangeGradeSheet>(find.byType(FilledButton)));

void main() {
  tearDown(Get.reset);

  group('edit name', () {
    testWidgets('opens from Profile with the design copy and the current name', (tester) async {
      await pumpProfile(tester);
      await openEditName(tester);
      expect(inSheet<EditNameSheet>(find.text(ProfileStrings.editName)), findsOneWidget);
      expect(inSheet<EditNameSheet>(find.text(ProfileSheetStrings.yourName)), findsOneWidget);
      expect(inSheet<EditNameSheet>(find.text(ProfileSheetStrings.nameNote)), findsOneWidget);
      expect(inSheet<EditNameSheet>(find.text(AppStrings.save)), findsOneWidget);
      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, 'أحمد');
    });

    testWidgets('an empty name shows the error and keeps the sheet open', (tester) async {
      final fixture = await pumpProfile(tester);
      await openEditName(tester);
      await tester.enterText(find.byType(TextField), '   ');
      await tapAndSettle(tester, find.text(AppStrings.save));
      expect(find.text(AppStrings.studentNameInvalid), findsOneWidget);
      expect(find.byType(EditNameSheet), findsOneWidget);
      expect(fixture.profiles.profile.name, 'أحمد');
    });

    testWidgets('a valid name is saved, closes the sheet and updates the header', (tester) async {
      final fixture = await pumpProfile(tester);
      await openEditName(tester);
      await tester.enterText(find.byType(TextField), ' سارة ');
      await tapAndSettle(tester, find.text(AppStrings.save));
      expect(fixture.profiles.profile.name, 'سارة');
      expect(find.byType(EditNameSheet), findsNothing);
      expect(find.text('سارة'), findsOneWidget);
    });

    testWidgets('the close button dismisses without saving', (tester) async {
      final fixture = await pumpProfile(tester);
      await openEditName(tester);
      await tester.enterText(find.byType(TextField), 'سارة');
      await tapAndSettle(tester, find.byIcon(LucideIcons.x));
      expect(find.byType(EditNameSheet), findsNothing);
      expect(fixture.profiles.profile.name, 'أحمد');
    });
  });

  group('change grade', () {
    testWidgets('marks the current grade and the grades coming soon', (tester) async {
      await pumpProfile(tester);
      await openChangeGrade(tester);
      expect(inSheet<ChangeGradeSheet>(find.text(AppStrings.changeGrade)), findsOneWidget);
      expect(find.byType(ChangeGradeTile), findsNWidgets(6));
      final current = _tile(tester, 9);
      expect(current.isCurrent && current.highlighted, isTrue);
      expect(current.onTap, isNull);
      expect(find.text(ProfileSheetStrings.currentGrade), findsOneWidget);
      for (final grade in [7, 8, 10, 11, 12]) {
        expect(_tile(tester, grade).available, isFalse, reason: '$grade');
        expect(_tile(tester, grade).onTap, isNull, reason: '$grade');
      }
      expect(find.text(AppStrings.comingSoon), findsNWidgets(5));
      expect(find.text(ProfileSheetStrings.gradeNoteTitle), findsOneWidget);
      expect(find.text(ProfileSheetStrings.gradeNoteBody), findsOneWidget);
      expect(find.text(ProfileSheetStrings.chooseGradeToContinue), findsOneWidget);
      expect(_footer(tester).onPressed, isNull);
    });

    testWidgets('tapping the current grade changes nothing', (tester) async {
      final fixture = await pumpProfile(tester);
      await openChangeGrade(tester);
      await tapAndSettle(tester, inSheet<ChangeGradeSheet>(find.text('التاسع')));
      expect(_footer(tester).onPressed, isNull);
      expect(find.byType(ChangeGradeSheet), findsOneWidget);
      expect(find.text('download'), findsNothing);
      expect(fixture.profiles.profile.grade, 9);
    });

    testWidgets('another offered grade enables the download and opens it', (tester) async {
      const inGrade10 = Profile(name: 'أحمد', grade: 10, themeMode: AppThemeMode.light);
      final fixture = await pumpProfile(tester, profile: inGrade10);
      await openChangeGrade(tester);
      expect(_tile(tester, 10).isCurrent, isTrue);
      expect(_tile(tester, 9).available, isTrue);
      await tapAndSettle(tester, inSheet<ChangeGradeSheet>(find.text('التاسع')));
      expect(_tile(tester, 9).highlighted, isTrue);
      expect(_tile(tester, 10).highlighted, isFalse);
      expect(find.text(ProfileSheetStrings.currentGrade), findsOneWidget);
      expect(fixture.profiles.profile.grade, 10);
      await tapAndSettle(tester, find.text(AppStrings.startDownload));
      expect(fixture.profiles.profile.grade, 9);
      expect(find.text('download'), findsOneWidget);
    });
  });

  group('about', () {
    testWidgets('shows the app, the source and the installed pack', (tester) async {
      await pumpProfile(tester);
      await openAbout(tester);
      for (final text in [
        ProfileStrings.about,
        AppStrings.appName,
        ProfileStrings.aboutSubtitle,
        ProfileStrings.noAccount,
        'رزمة الصف التاسع · الإصدار 3',
      ]) {
        expect(inSheet<AboutSheet>(find.text(text)), findsOneWidget, reason: text);
      }
    });

    testWidgets('leaves out the pack line before a pack is installed', (tester) async {
      const noPack = Profile(name: 'أحمد', grade: 9, themeMode: AppThemeMode.light);
      await pumpProfile(tester, profile: noPack);
      await openAbout(tester);
      expect(inSheet<AboutSheet>(find.textContaining(ProfileStrings.packSegment)), findsNothing);
      expect(inSheet<AboutSheet>(find.text(AppStrings.appName)), findsOneWidget);
    });
  });
}
