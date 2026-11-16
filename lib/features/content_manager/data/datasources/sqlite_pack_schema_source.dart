import 'dart:io';
import 'dart:isolate';

import 'package:sqlite3/sqlite3.dart';

import 'pack_schema_source.dart';

/// Opens the file with raw sqlite3 rather than drift, so an old pack is only
/// inspected and never migrated.
class SqlitePackSchemaSource implements PackSchemaSource {
  const SqlitePackSchemaSource();

  @override
  Future<int?> schemaVersionOf(File contentDb) {
    final path = contentDb.path;
    return Isolate.run(() => _read(path));
  }

  static int? _read(String path) {
    if (!File(path).existsSync()) return null;
    Database? db;
    try {
      db = sqlite3.open(path, mode: OpenMode.readOnly);
      final rows = db.select(
          "SELECT value FROM pack_meta WHERE key = 'schema_version'");
      if (rows.isEmpty) return null;
      return int.tryParse('${rows.first['value']}'.trim());
    } on SqliteException {
      return null;
    } finally {
      db?.close();
    }
  }
}