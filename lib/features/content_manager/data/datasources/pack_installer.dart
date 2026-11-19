import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';

import '../../../../core/db/content/content_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/app_paths_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/settings_service.dart';
import 'core_pack_install_host.dart';
import 'pack_install_files.dart';
import 'pack_install_host.dart';
import 'pack_install_journal.dart';
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
        _schemas = schemas,
        _files = PackInstallFiles(_host);

  final PackInstallHost _host;
  final PackInstallFiles _files;
  final PackRename _rename;
  final PackSchemaSource _schemas;

  Future<void> install(File zip, int version) async {
    final staging = _files.staging;
    var ok = false, journaled = false;
    try {
      await _deleteIfExists(staging);
      await staging.create(recursive: true);
      await Isolate.run(() => extractFileToDisk(zip.path, staging.path));
      final newDb = _files.stagedDb;
      if (!await newDb.exists()) {
        throw const ManifestException('pack has no content.db');
      }
      await _ensureSchema(newDb);
      final newPdf = await _files.stagedPdf.exists() ? _files.stagedPdf : null;
      await PackInstallJournal(
        from: _host.installedVersion,
        to: version,
        swapsPdf: newPdf != null,
      ).writeTo(_files.journal, _files.journalTemp);
      journaled = true;
      await _swap(newDb, newPdf, version);
      ok = true;
    } finally {
      if (ok) {
        await _deleteQuietly(_files.dbBackup);
        await _deleteQuietly(_files.pdfBackup);
      }
      if (journaled) await _deleteQuietly(_files.journal);
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
    final dbBak = _files.dbBackup;
    final pdf = _host.pdfDir;
    final pdfBak = _files.pdfBackup;
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
      // Backup stays as <name>.bak; PackRecovery restores it at next launch.
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
