import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/device_capability_service.dart';
import '../../domain/repositories/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  StorageRepositoryImpl(this._device);
  final DeviceCapabilityService _device;

  @override
  Future<Either<Failure, Unit>> ensureFreeSpace(int requiredBytes) async {
    final free = await _device.refreshFreeSpace();
    // Platforms that can't report free space are allowed to proceed.
    if (free == null || free >= requiredBytes) return const Right(unit);
    return Left(NotEnoughSpaceFailure(requiredBytes: requiredBytes, freeBytes: free));
  }
}
