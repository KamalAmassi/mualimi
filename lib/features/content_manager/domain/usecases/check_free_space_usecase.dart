import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/storage_repository.dart';

class CheckFreeSpaceUseCase implements UseCase<Unit, int> {
  CheckFreeSpaceUseCase(this._storage);
  final StorageRepository _storage;

  @override
  Future<Either<Failure, Unit>> call(int requiredBytes) =>
      _storage.ensureFreeSpace(requiredBytes);
}
