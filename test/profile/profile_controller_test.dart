import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/features/profile/domain/entities/app_theme_mode.dart';
import 'package:mualimi/features/profile/domain/entities/pack_update_check.dart';
import 'package:mualimi/features/profile/domain/entities/profile.dart';
import 'package:mualimi/features/profile/domain/entities/storage_usage.dart';
import 'package:mualimi/features/profile/presentation/widgets/profile_strings.dart';

import 'profile_fakes.dart';

Future<void> _flush() => Future<void>.delayed(Duration.zero);

void main() {
  tearDown(Get.reset);

  test('loads storage on init', () async {
    final fixture = ProfileFixture();
    final controller = Get.put(fixture.controller());
    await _flush();
    expect(controller.storage.value,
        const StorageUsage(packBytes: 30 << 20, pdfBytes: 10 << 20));
  });

  test('header, grade and pack labels', () {
    final controller = ProfileFixture().controller();
    expect(controller.initial, 'أ');
    expect(controller.headerSubtitle, 'الصف التاسع · ${ProfileStrings.noAccount}');
    expect(controller.gradeOrdinal, 'التاسع');
    expect(controller.packSubtitle, 'الإصدار 3');
  });

  test('without a grade or a name the labels stay empty', () {
    final controller = ProfileFixture(
      profile: const Profile(name: '', grade: null, themeMode: AppThemeMode.system),
    ).controller();
    expect(controller.initial, '');
    expect(controller.headerSubtitle, ProfileStrings.noAccount);
    expect(controller.gradeOrdinal, '');
    expect(controller.packSubtitle, '');
  });

  test('font size cycles 1.0 -> 1.15 -> 1.3 -> 1.0 with its labels', () async {
    final fixture = ProfileFixture();
    final controller = fixture.controller();
    expect(controller.fontScaleLabel, ProfileStrings.fontMedium);
    await controller.cycleFontScale();
    expect(fixture.profiles.profile.fontScale, 1.15);
    expect(controller.fontScaleLabel, ProfileStrings.fontLarge);
    await controller.cycleFontScale();
    expect(fixture.profiles.profile.fontScale, 1.3);
    expect(controller.fontScaleLabel, ProfileStrings.fontExtraLarge);
    await controller.cycleFontScale();
    expect(fixture.profiles.profile.fontScale, 1.0);
  });

  test('a saved scale between steps shows the nearest label and steps up', () async {
    final fixture = ProfileFixture(
      profile: const Profile(
          name: 'أحمد', grade: 9, themeMode: AppThemeMode.light, fontScale: 1.2),
    );
    final controller = fixture.controller();
    expect(controller.fontScaleLabel, ProfileStrings.fontLarge);
    await controller.cycleFontScale();
    expect(fixture.profiles.profile.fontScale, 1.3);
  });

  test('theme selection saves each mode', () async {
    final fixture = ProfileFixture();
    final controller = fixture.controller();
    for (final mode in AppThemeMode.values) {
      await controller.setTheme(mode);
      expect(fixture.profiles.profile.themeMode, mode);
      expect(controller.current.themeMode, mode);
    }
  });

  test('an empty name is rejected, a valid one saved', () async {
    final fixture = ProfileFixture();
    final controller = fixture.controller();
    expect(await controller.saveName('  '), isFalse);
    expect(controller.nameInvalid.value, isTrue);
    expect(await controller.saveName('سلمى'), isTrue);
    expect(fixture.profiles.profile.name, 'سلمى');
  });

  group('update check', () {
    test('online and current shows «محدّثة»', () async {
      final fixture = ProfileFixture(updateResult: PackUpdateCheck.upToDate);
      final controller = fixture.controller();
      await controller.checkForUpdate();
      expect(fixture.updates.checkedGrades, [9]);
      expect(controller.packSubtitle, 'الإصدار 3 · محدّثة');
      expect(fixture.updateSheetOpens, 0);
    });

    test('offline or no manifest keeps only the version', () async {
      final fixture = ProfileFixture(updateResult: PackUpdateCheck.unavailable);
      final controller = fixture.controller();
      await controller.checkForUpdate();
      expect(controller.packSubtitle, 'الإصدار 3');
      expect(fixture.updateSheetOpens, 0);
    });

    test('a newer pack opens the update sheet', () async {
      final fixture = ProfileFixture(updateResult: PackUpdateCheck.updateAvailable);
      final controller = fixture.controller();
      await controller.checkForUpdate();
      expect(fixture.updateSheetOpens, 1);
      expect(controller.upToDate.value, isFalse);
    });

    test('no grade means nothing is checked', () async {
      final fixture = ProfileFixture(
        profile: const Profile(name: 'أحمد', grade: null, themeMode: AppThemeMode.light),
      );
      await fixture.controller().checkForUpdate();
      expect(fixture.updates.checkedGrades, isEmpty);
    });

    test('a new pack version clears «محدّثة» and remeasures storage', () async {
      final fixture = ProfileFixture();
      final controller = Get.put(fixture.controller());
      await _flush();
      await controller.checkForUpdate();
      expect(controller.upToDate.value, isTrue);
      final callsBefore = fixture.storage.calls;
      fixture.profiles.emit(const Profile(
          name: 'أحمد', grade: 9, themeMode: AppThemeMode.light, packVersion: 4));
      await _flush();
      expect(controller.upToDate.value, isFalse);
      expect(controller.packSubtitle, 'الإصدار 4');
      expect(fixture.storage.calls, callsBefore + 1);
    });
  });
}
