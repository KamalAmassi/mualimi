import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

/// Writes a minimal content.db at [path] with a `pack_meta` table. The
/// `schema_version` row is written only when [schemaVersion] is given.
File writeContentDb(String path, {String? schemaVersion, String marker = 'db'}) {
  final file = File(path)..parent.createSync(recursive: true);
  if (file.existsSync()) file.deleteSync();
  final db = sqlite3.open(path);
  try {
    db.execute('CREATE TABLE pack_meta (key TEXT PRIMARY KEY, value TEXT NOT NULL)');
    db.execute("INSERT INTO pack_meta VALUES ('marker', ?)", [marker]);
    if (schemaVersion != null) {
      db.execute("INSERT INTO pack_meta VALUES ('schema_version', ?)", [schemaVersion]);
    }
  } finally {
    db.close();
  }
  return file;
}

/// The `marker` row of a content.db written by [writeContentDb].
String contentDbMarker(String path) {
  final db = sqlite3.open(path, mode: OpenMode.readOnly);
  try {
    return db.select("SELECT value FROM pack_meta WHERE key = 'marker'").first['value']
        as String;
  } finally {
    db.close();
  }
}
