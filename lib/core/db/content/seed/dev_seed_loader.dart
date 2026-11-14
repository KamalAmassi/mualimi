import 'package:drift/native.dart';

import '../../../services/app_paths_service.dart';
import '../../../services/database_service.dart';
import '../../../services/settings_service.dart';
import '../content_database.dart';
import 'dev_seed_science_g9.dart';

/// Installs the development pack on a fresh debug install so the app opens
/// straight into the shell with something to study.
abstract final class DevSeedLoader {
  static const _studentName = 'طالب';

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
