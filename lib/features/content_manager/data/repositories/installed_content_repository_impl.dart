import 'dart:io';

import '../../../../core/db/content/content_database.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../domain/entities/pack_schema_status.dart';
import '../../domain/repositories/installed_content_repository.dart';
import '../datasources/pack_schema_source.dart';

class InstalledContentRepositoryImpl implements InstalledContentRepository {
  InstalledContentRepositoryImpl(
      this._settings, this._databases, this._schemas, this._contentDb);

  final SettingsService _settings;
  final DatabaseService _databases;
  final PackSchemaSource _schemas;
  final File _contentDb;

  @override
  Future<int?> installedPackVersion() async => _settings.installedPackVersion.value;

  @override
  Future<bool> isPackInstalled() async =>
      await installedSchemaStatus() == PackSchemaStatus.compatible;

  @override
  Future<PackSchemaStatus?> installedSchemaStatus() async {
    final present =
        _settings.installedPackVersion.value != null && _databases.hasContent;
    if (!present) return null;
    final found = await _schemas.schemaVersionOf(_contentDb);
    return PackSchemaStatus.of(found, ContentDatabase.packSchemaVersion);
  }
}
