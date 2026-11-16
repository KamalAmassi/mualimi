import '../entities/pack_schema_status.dart';

abstract class InstalledContentRepository {
  Future<int?> installedPackVersion();

  /// True only when a pack is installed and its schema is [PackSchemaStatus.compatible].
  Future<bool> isPackInstalled();

  /// Null when no pack is installed.
  Future<PackSchemaStatus?> installedSchemaStatus();
}
