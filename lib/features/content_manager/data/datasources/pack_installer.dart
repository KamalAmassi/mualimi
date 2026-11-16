import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;

import '../../../../core/constants/app_files.dart';
import '../../../../core/db/content/content_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/app_paths_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/settings_service.dart';
import 'core_pack_install_host.dart';
import 'pack_install_host.dart';
import 'pack_schema_source.dart';
import 'sqlite_pack_schema_source.dart';

/// Renames [entity] to [newPath]. Injectable so tests can simulate a failure.
typedef PackRename = Future<FileSystemEntity> Function(
    FileSystemEntity entity, String newPath);

Future<FileSystemEntity> _defaultRename(FileSystemEntity e, String newPath) =>
    e.rename(newPath);

/// Installs a verified pack zip atomically: content.db (+ pdf/ when the pack
/// has one) are swapped in with a backup, rolled back on any failure, and the
/// content DB is always reopened. A pack whose schema_version does not match
/// is rejected before anything is swapped. user.db and anything outside
/// packsDir are never touched.
class PackInstaller {
  PackInstaller(AppPathsService paths, DatabaseService databases, SettingsService settings)
      : this.withHost(CorePackInstallHost(paths, databases, settings));

  PackInstaller.withHost(
    this._host, {
    PackRename rename = _defaultRename,
    PackSchemaSource schemas = const SqlitePackSchemaSource(),
  })  : _rename = rename,
        _schemas = schemas;

  static const _bakSuffix = '.bak';

  final PackInstallHost _host;
  final PackRename _rename;
  final PackSchemaSource _schemas;

  Future<void> install(File zip, int version) async {
    final staging = Directory(p.join(_host.packsDir.path, 'staging'));
    var ok = false;
    try {
      await _deleteIfExists(staging);
      await staging.create(recursive: true);
      await Isolate.run(() => extractFileToDisk(zip.path, staging.path));
      final newDb = File(p.join(staging.path, AppFiles.contentDb));
      if (!await newDb.exists()) {
        throw const ManifestException('pack has no content.db');
      }
      await _ensureSchema(newDb);
      final newPdf = Directory(p.join(staging.path, AppFiles.pdfDir));
      await _swap(newDb, await newPdf.exists() ? newPdf : null, version);
      ok = true;
    } finally {
      if (ok) {
        await _deleteQuietly(File('${_host.contentDbFile.path}$_bakSuffix'));
        await _deleteQuietly(Directory('${_host.pdfDir.path}$_bakSuffix'));
      }
      await _deleteQuietly(staging);
      await _deleteQuietly(zip);
    }
  }

  Future<void> _ensureSchema(File newDb) async {
    const expected = ContentDatabase.packSchemaVersion;
    final found = await _schemas.schemaVersionOf(newDb);
    if (found != expected) {
      throw ManifestException('pack schema_version $found, expected $expected');
    }
  }

  /// Closes the content DB, swaps the files in with backups, writes the
  /// version, and rolls back on any error. Always reopens the DB.
  Future<void> _swap(File newDb, Directory? newPdf, int version) async {
    final db = _host.contentDbFile;
    final dbBak = File('${db.path}$_bakSuffix');
    final pdf = _host.pdfDir;
    final pdfBak = Directory('${pdf.path}$_bakSuffix');
    final oldVersion = _host.installedVersion;
    var dbBacked = false, dbPlaced = false, pdfBacked = false, pdfPlaced = false;
    var versionTried = false;

    await _host.closeContent();
    try {
      if (await db.exists()) {
        await _deleteIfExists(dbBak); // stale backup from an earlier crash
        await _rename(db, dbBak.path);
        dbBacked = true;
      }
      await _deleteIfExists(db);
      await _rename(newDb, db.path);
      dbPlaced = true;

      if (newPdf != null) {
        if (await pdf.exists()) {
          await _deleteIfExists(pdfBak);
          await _rename(pdf, pdfBak.path);
          pdfBacked = true;
        }
        await _deleteIfExists(pdf);
        await _rename(newPdf, pdf.path);
        pdfPlaced = true;
      }

      versionTried = true;
      await _host.setInstalledVersion(version);
    } catch (_) {
      await _restore(pdf, pdfBak, placed: pdfPlaced, backed: pdfBacked);
      await _restore(db, dbBak, placed: dbPlaced, backed: dbBacked);
      if (versionTried) await _restoreVersion(oldVersion);
      rethrow;
    } finally {
      // Only reopen when a file is there, mirroring DatabaseService.init.
      if (await db.exists()) _host.openContent();
    }
  }

  /// Removes a partially placed [target] and moves [backup] back. Each step
  /// is best-effort so one failure does not hide the original error.
  Future<void> _restore(
    FileSystemEntity target,
    FileSystemEntity backup, {
    required bool placed,
    required bool backed,
  }) async {
    if (placed || backed) await _deleteQuietly(target);
    if (!backed) return;
    try {
      await _rename(backup, target.path);
    } catch (_) {
      // Backup stays as <name>.bak; a startup recovery step can restore it.
    }
  }

  /// The settings write may update memory before failing on disk.
  Future<void> _restoreVersion(int? oldVersion) async {
    try {
      await _host.setInstalledVersion(oldVersion);
    } catch (_) {}
  }

  Future<void> _deleteIfExists(FileSystemEntity e) async {
    if (await e.exists()) await e.delete(recursive: true);
  }

  Future<void> _deleteQuietly(FileSystemEntity e) async {
    try {
      await _deleteIfExists(e);
    } catch (_) {
      // Leftovers are harmless: the next install clears stale staging/.bak.
    }
  }
}
