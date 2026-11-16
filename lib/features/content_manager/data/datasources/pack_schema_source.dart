import 'dart:io';

/// Reads `pack_meta.schema_version` from a content.db file.
abstract class PackSchemaSource {
  /// Null when the file is not a readable pack or the value is missing.
  Future<int?> schemaVersionOf(File contentDb);
}
