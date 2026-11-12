import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;

import '../../../../core/constants/app_files.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/app_paths_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/settings_service.dart';

/// Installs a verified pack zip: content.db (+ optional pdf/) replace the old
/// pack wholesale. user.db is never touched.
class PackInstaller {
  PackInstaller(this._paths, this._databases, this._settings);

  final AppPathsService _paths;
  final DatabaseService _databases;
  final SettingsService _settings;

  Future<void> install(File zip, int version) async {
    final staging = Directory(p.join(_paths.packsDir.path, 'staging'));
    if (await staging.exists()) await staging.delete(recursive: true);
    await staging.create(recursive: true);

    await Isolate.run(() => extractFileToDisk(zip.path, staging.path));
    final newDb = File(p.join(staging.path, AppFiles.contentDb));
    if (!await newDb.exists()) {
      throw const ManifestException('pack has no content.db');
    }

    await _databases.closeContent();
    final target = _paths.contentDbFile;
    if (await target.exists()) await target.delete();
    await newDb.rename(target.path);

    final newPdf = Directory(p.join(staging.path, AppFiles.pdfDir));
    if (await newPdf.exists()) {
      if (await _paths.pdfDir.exists()) await _paths.pdfDir.delete(recursive: true);
      await newPdf.rename(_paths.pdfDir.path);
    }

    _databases.openContent();
    await _settings.setInstalledPackVersion(version);
    await staging.delete(recursive: true);
    await zip.delete();
  }
}
