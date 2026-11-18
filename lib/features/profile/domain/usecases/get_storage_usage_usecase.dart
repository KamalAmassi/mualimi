import '../entities/storage_usage.dart';
import '../repositories/storage_usage_repository.dart';

class GetStorageUsageUseCase {
  GetStorageUsageUseCase(this._repository);
  final StorageUsageRepository _repository;

  Future<StorageUsage> call() => _repository.getUsage();
}