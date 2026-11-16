import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';

import '../../../services/app_paths_service.dart';
import '../../../services/database_service.dart';
import '../../../services/settings_service.dart';
import '../content_database.dart';
import 'dev_seed_science_g9.dart';

/// Installs the development pack on a fresh install so the app opens straight
/// into the shell with something to study. It only runs in debug builds started
/// with `--dart-define=DEV_SEED=true`; otherwise onboarding runs as usual.
abstract final class DevSeedLoader {
  static const _studentName = 'طالب';
  static const _flag = bool.fromEnvironment('DEV_SEED');

  static bool isEnabled({bool debugMode = kDebugMode, bool flagSet = _flag}) =>
      debugMode && flagSet;

  static Future<void> installIfMissing(
    AppPathsService paths,
    SettingsService settings,
    DatabaseService databases,
  ) async {
    if (paths.contentDbFile.existsSync()) return;
    final db = ContentDatabase(NativeDatabase(paths.contentDbFile));
    await DevSeedScienceG9.insert(db);
    await db.close();
    databases.openContent();
    await settings.setStudentName(_studentName);
    await settings.setGrade(9);
    await settings.setInstalledPackVersion(1);
    await settings.setOnboardingDone(true);
  }
}
