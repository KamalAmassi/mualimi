import '../../../../core/services/database_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../domain/repositories/installed_content_repository.dart';

class InstalledContentRepositoryImpl implements InstalledContentRepository {
  InstalledContentRepositoryImpl(this._settings, this._databases);

  final SettingsService _settings;
  final DatabaseService _databases;

  @override
  Future<int?> installedPackVersion() async => _settings.installedPackVersion.value;

  @override
  Future<bool> isPackInstalled() async =>
      _settings.installedPackVersion.value != null && _databases.hasContent;
}
