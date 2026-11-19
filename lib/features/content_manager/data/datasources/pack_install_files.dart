import 'dart:io';

import 'package:path/path.dart' as p;

import '../../../../core/constants/app_files.dart';
import 'pack_install_host.dart';

/// Working paths of a pack install, shared by [PackInstaller] and
/// [PackRecovery] so both agree on what an interrupted install leaves behind.
class PackInstallFiles {
  const PackInstallFiles(this._host);

  static const _backupSuffix = '.bak';

  final PackInstallHost _host;

  Directory get staging => Directory(p.join(_host.packsDir.path, 'staging'));

  File get stagedDb => File(p.join(staging.path, AppFiles.contentDb));

  Directory get stagedPdf => Directory(p.join(staging.path, AppFiles.pdfDir));

  File get dbBackup => File('${_host.contentDbFile.path}$_backupSuffix');

  Directory get pdfBackup => Directory('${_host.pdfDir.path}$_backupSuffix');

  File get journal => File(p.join(_host.packsDir.path, 'install_journal.json'));

  File get journalTemp => File('${journal.path}.tmp');
}
