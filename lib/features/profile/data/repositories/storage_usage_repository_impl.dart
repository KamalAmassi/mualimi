import '../../domain/entities/storage_usage.dart';
import '../../domain/repositories/storage_usage_repository.dart';
import '../datasources/storage_usage_local_data_source.dart';

class StorageUsageRepositoryImpl implements StorageUsageRepository {
  StorageUsageRepositoryImpl(this._local);
  final StorageUsageLocalDataSource _local;

  @override
  Future<StorageUsage> getUsage() => _local.measure();
}