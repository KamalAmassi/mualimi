import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/services/database_service.dart';
import 'package:mualimi/core/services/settings_service.dart';
import 'package:mualimi/features/content_manager/data/datasources/sqlite_pack_schema_source.dart';
import 'package:mualimi/features/content_manager/data/repositories/installed_content_repository_impl.dart';
import 'package:mualimi/features/content_manager/domain/entities/pack_schema_status.dart';
import 'package:path/path.dart' as p;

import 'helpers/content_db_fixture.dart';

class _FakeDatabases extends Fake implements DatabaseService {
  _FakeDatabases(this.hasContent);

  @override
  final bool hasContent;
}

const _current = ContentDatabase.packSchemaVersion;

void main() {
  late Directory root;
  late File contentDb;
  late SettingsService settings;

  setUp(() {
    root = Directory.systemTemp.createTempSync('installed_content_');
    contentDb = File(p.join(root.path, 'content.db'));
    settings = SettingsService(File(p.join(root.path, 'settings.json')))
      ..installedPackVersion.value = 4;
  });

  tearDown(() => root.deleteSync(recursive: true));

  InstalledContentRepositoryImpl repository({bool hasContent = true}) =>
      InstalledContentRepositoryImpl(settings, _FakeDatabases(hasContent),
          const SqlitePackSchemaSource(), contentDb);

  test('matching schema_version is usable', () async {
    writeContentDb(contentDb.path, schemaVersion: '$_current');

    expect(await repository().installedSchemaStatus(), PackSchemaStatus.compatible);
    expect(await repository().isPackInstalled(), isTrue);
  });

  for (final (schema, status) in [
    ('${_current - 1}', PackSchemaStatus.outdated),
    ('${_current + 1}', PackSchemaStatus.newer),
    (null, PackSchemaStatus.unreadable),
  ]) {
    test('schema_version $schema needs re-download as $status', () async {
      writeContentDb(contentDb.path, schemaVersion: schema);

      expect(await repository().installedSchemaStatus(), status);
      expect(await repository().isPackInstalled(), isFalse);
    });
  }

  test('no installed pack reports no schema status', () async {
    settings.installedPackVersion.value = null;

    expect(await repository().installedSchemaStatus(), isNull);
    expect(await repository(hasContent: false).isPackInstalled(), isFalse);
  });
}
