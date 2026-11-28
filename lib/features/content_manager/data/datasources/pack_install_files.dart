import 'dart:io';

import 'package:path/path.dart' as p;

import '../../../../core/constants/app_files.dart';
import 'pack_install_host.dart';
import 'pack_swap_entry.dart';

/// Working paths of a pack install, shared by [PackInstaller] and
/// [PackRecovery] so both agree on what an interrupted install leaves behind.
class PackInstallFiles {
  const PackInstallFiles(this._host);

  static const _backupSuffix = '.bak';
  static const _imagesDir = 'images';

  final PackInstallHost _host;

  Directory get staging => Directory(p.join(_host.packsDir.path, 'staging'));

  File get stagedDb => File(p.join(staging.path, AppFiles.contentDb));

  Directory get stagedPdf => Directory(p.join(staging.path, AppFiles.pdfDir));

  Directory get stagedImages => Directory(p.join(staging.path, _imagesDir));

  /// Where the lesson viewer reads `images/<file>.webp` from.
  Directory get images => Directory(p.join(_host.packsDir.path, _imagesDir));

  File get dbBackup => File('${_host.contentDbFile.path}$_backupSuffix');

  Directory get pdfBackup => Directory('${_host.pdfDir.path}$_backupSuffix');

  Directory get imagesBackup => Directory('${images.path}$_backupSuffix');

  PackSwapEntry get dbSwap =>
      PackSwapEntry(target: _host.contentDbFile, backup: dbBackup, staged: stagedDb);

  PackSwapEntry get pdfSwap =>
      PackSwapEntry(target: _host.pdfDir, backup: pdfBackup, staged: stagedPdf);

  PackSwapEntry get imagesSwap =>
      PackSwapEntry(target: images, backup: imagesBackup, staged: stagedImages);

  File get journal => File(p.join(_host.packsDir.path, 'install_journal.json'));

  File get journalTemp => File('${journal.path}.tmp');
}
