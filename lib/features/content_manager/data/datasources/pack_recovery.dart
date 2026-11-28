import 'dart:io';

import '../../../../core/services/app_paths_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/settings_service.dart';
import 'core_pack_install_host.dart';
import 'pack_install_files.dart';
import 'pack_install_host.dart';
import 'pack_install_journal.dart';

/// Repairs what a [PackInstaller] killed mid-swap leaves on disk. Runs at
/// startup before the content DB is opened, and is safe to run any number of
/// times: each step checks the disk first and the journal is removed last.
///
/// The version write is the install's commit point: with a journal, the new
/// pack is kept only when it is fully in place and the stored version already
/// names it; anything earlier is rolled back to the backups and old version.
class PackRecovery {
  /// The [DatabaseService] here is never opened; recovery only moves files.
  PackRecovery(AppPathsService paths, SettingsService settings)
      : this.withHost(
            CorePackInstallHost(paths, DatabaseService(paths), settings));

  PackRecovery.withHost(this._host) : _files = PackInstallFiles(_host);

  final PackInstallHost _host;
  final PackInstallFiles _files;

  /// A file error never blocks startup: the disk is left for the next launch
  /// to retry, and the journal is still there to guide it.
  Future<void> run() async {
    try {
      await _recover();
    } on FileSystemException {
      return;
    }
  }

  Future<void> _recover() async {
    final journal = await PackInstallJournal.readFrom(_files.journal);
    if (journal == null) {
      await _restoreOrDropBackup(_host.contentDbFile, _files.dbBackup);
      await _restoreOrDropBackup(_host.pdfDir, _files.pdfBackup);
      await _restoreOrDropBackup(_files.images, _files.imagesBackup);
    } else if (await _isCommitted(journal)) {
      await _deleteIfExists(_files.dbBackup);
      await _deleteIfExists(_files.pdfBackup);
      await _deleteIfExists(_files.imagesBackup);
    } else {
      await _rollBack(journal);
    }
    await _deleteIfExists(_files.staging);
    await _deleteIfExists(_files.journalTemp);
    await _deleteIfExists(_files.journal);
  }

  Future<bool> _isCommitted(PackInstallJournal journal) async {
    if (_host.installedVersion != journal.to) return false;
    if (!await _host.contentDbFile.exists() || await _files.stagedDb.exists()) {
      return false;
    }
    if (journal.swapsPdf &&
        !await _isPlaced(_host.pdfDir, _files.stagedPdf)) {
      return false;
    }
    return !journal.swapsImages ||
        await _isPlaced(_files.images, _files.stagedImages);
  }

  Future<bool> _isPlaced(Directory target, Directory staged) async =>
      await target.exists() && !await staged.exists();

  Future<void> _rollBack(PackInstallJournal journal) async {
    if (journal.swapsImages) {
      await _restore(_files.images, _files.imagesBackup);
    }
    if (journal.swapsPdf) await _restore(_host.pdfDir, _files.pdfBackup);
    await _restore(_host.contentDbFile, _files.dbBackup);
    if (_host.installedVersion != journal.from) {
      await _host.setInstalledVersion(journal.from);
    }
  }

  Future<void> _restore(FileSystemEntity target, FileSystemEntity backup) async {
    if (!await backup.exists()) return;
    await _deleteIfExists(target);
    await backup.rename(target.path);
  }

  /// Without a journal the swap never started or its rollback already ran:
  /// a backup is needed only when its target is missing.
  Future<void> _restoreOrDropBackup(
      FileSystemEntity target, FileSystemEntity backup) async {
    if (!await backup.exists()) return;
    if (await target.exists()) {
      await backup.delete(recursive: true);
    } else {
      await backup.rename(target.path);
    }
  }

  Future<void> _deleteIfExists(FileSystemEntity e) async {
    if (await e.exists()) await e.delete(recursive: true);
  }
}
