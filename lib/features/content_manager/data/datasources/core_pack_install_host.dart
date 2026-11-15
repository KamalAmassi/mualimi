import 'dart:io';

import '../../../../core/services/app_paths_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/settings_service.dart';
import 'pack_install_host.dart';

/// Real [PackInstallHost]: delegates to the shared core services unchanged.
class CorePackInstallHost implements PackInstallHost {
  CorePackInstallHost(this._paths, this._databases, this._settings);

  final AppPathsService _paths;
  final DatabaseService _databases;
  final SettingsService _settings;

  @override
  Directory get packsDir => _paths.packsDir;

  @override
  File get contentDbFile => _paths.contentDbFile;

  @override
  Directory get pdfDir => _paths.pdfDir;

  @override
  Future<void> closeContent() => _databases.closeContent();

  @override
  void openContent() => _databases.openContent();

  @override
  int? get installedVersion => _settings.installedPackVersion.value;

  @override
  Future<void> setInstalledVersion(int? version) =>
      _settings.setInstalledPackVersion(version);
}
