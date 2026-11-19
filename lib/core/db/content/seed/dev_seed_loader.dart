import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';

import '../../../services/app_paths_service.dart';
import '../../../services/database_service.dart';
import '../../../services/settings_service.dart';
import '../content_database.dart';
import 'dev_seed_science_g9.dart';

/// Installs the development pack on a fresh install so the app opens straight
/// into the shell with something to study. It runs in debug and profile builds
/// started with `--dart-define=DEV_SEED=true`, never in release; otherwise
/// onboarding runs as usual.
abstract final class DevSeedLoader {
  static const _studentName = 'طالب';
  static const _flag = bool.fromEnvironment('DEV_SEED');

  static bool isEnabled(
          {bool releaseMode = kReleaseMode, bool flagSet = _flag}) =>
      !releaseMode && flagSet;

  static Future<void> installIfMissing(
    AppPathsService paths,
    SettingsService settings,
    DatabaseService databases,
  ) async {
    final file = paths.contentDbFile;
    if (file.existsSync()) {
      if (await _hasCurrentSchema(databases)) return;
      await databases.closeContent();
      file.deleteSync();
    }
    final db = ContentDatabase(NativeDatabase(file));
    await DevSeedScienceG9.insert(db);
    await db.close();
    databases.openContent();
    await settings.setStudentName(_studentName);
    await settings.setGrade(9);
    await settings.setInstalledPackVersion(1);
    await settings.setOnboardingDone(true);
  }

  /// Development databases from older schemas are rebuilt, never migrated.
  static Future<bool> _hasCurrentSchema(DatabaseService databases) async {
    try {
      final rows = await databases.content
          .customSelect(
              "SELECT value FROM pack_meta WHERE key = 'schema_version'")
          .get();
      return rows.isNotEmpty &&
          rows.first.read<String>('value') ==
              '${ContentDatabase.packSchemaVersion}';
    } on Exception {
      return false;
    }
  }
}
