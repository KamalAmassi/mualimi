import 'dart:io';
import 'dart:isolate';

import '../../../../core/db/content/content_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/app_paths_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/settings_service.dart';
import 'core_pack_install_host.dart';
import 'pack_archive_extractor.dart';
import 'pack_install_files.dart';
import 'pack_install_host.dart';
import 'pack_install_journal.dart';
import 'pack_schema_source.dart';
import 'pack_swap_entry.dart';
import 'sqlite_pack_schema_source.dart';

/// Renames [entity] to [newPath]. Injectable so tests can simulate a failure.
typedef PackRename = Future<FileSystemEntity> Function(
    FileSystemEntity entity, String newPath);

Future<FileSystemEntity> _defaultRename(FileSystemEntity e, String newPath) =>
    e.rename(newPath);

/// Installs a verified pack zip atomically: content.db (+ pdf/ and images/
/// when the pack has them) are swapped in with a backup, rolled back on any
/// failure, and the content DB is always reopened. A pack whose
/// schema_version does not match, or whose layout is malformed, is rejected
/// before anything is swapped. user.db and anything outside packsDir are
/// never touched.
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
    final swaps = <PackSwapEntry>[];
    try {
      await _deleteIfExists(staging);
      await staging.create(recursive: true);
      await Isolate.run(() => PackArchiveExtractor.extract(zip.path, staging.path));
      final newDb = _files.stagedDb;
      if (!await newDb.exists()) {
        throw const ManifestException('pack has no content.db');
      }
      await _ensureSchema(newDb);
      final swapsPdf = await _files.stagedPdf.exists();
      final swapsImages = await _files.stagedImages.exists();
      swaps.addAll([
        _files.dbSwap,
        if (swapsPdf) _files.pdfSwap,
        if (swapsImages) _files.imagesSwap,
      ]);
      await PackInstallJournal(
        from: _host.installedVersion,
        to: version,
        swapsPdf: swapsPdf,
        swapsImages: swapsImages,
      ).writeTo(_files.journal, _files.journalTemp);
      journaled = true;
      await _swap(swaps, version);
      ok = true;
    } finally {
      if (ok) {
        for (final swap in swaps) {
          await _deleteQuietly(swap.backup);
        }
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

  /// Closes the content DB, moves each staged entry in (in order) with a
  /// backup, writes the version, and rolls back on any error. Always reopens
  /// the DB.
  Future<void> _swap(List<PackSwapEntry> swaps, int version) async {
    final oldVersion = _host.installedVersion;
    final backedUp = <PackSwapEntry>{}, placed = <PackSwapEntry>{};
    var versionTried = false;

    await _host.closeContent();
    try {
      for (final swap in swaps) {
        if (await swap.target.exists()) {
          await _deleteIfExists(swap.backup); // stale backup from an earlier crash
          await _rename(swap.target, swap.backup.path);
          backedUp.add(swap);
        }
        await _deleteIfExists(swap.target);
        await _rename(swap.staged, swap.target.path);
        placed.add(swap);
      }

      versionTried = true;
      await _host.setInstalledVersion(version);
    } catch (_) {
      for (final swap in swaps.reversed) {
        await _restore(swap,
            placed: placed.contains(swap), backedUp: backedUp.contains(swap));
      }
      if (versionTried) await _restoreVersion(oldVersion);
      rethrow;
    } finally {
      // Only reopen when a file is there, mirroring DatabaseService.init.
      if (await _host.contentDbFile.exists()) _host.openContent();
    }
  }

  /// Removes a partially placed target and moves its backup back. Each step
  /// is best-effort so one failure does not hide the original error.
  Future<void> _restore(
    PackSwapEntry swap, {
    required bool placed,
    required bool backedUp,
  }) async {
    if (placed || backedUp) await _deleteQuietly(swap.target);
    if (!backedUp) return;
    try {
      await _rename(swap.backup, swap.target.path);
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
