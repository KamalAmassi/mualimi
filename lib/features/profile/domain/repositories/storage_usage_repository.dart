import '../entities/storage_usage.dart';

abstract class StorageUsageRepository {
  Future<StorageUsage> getUsage();
}