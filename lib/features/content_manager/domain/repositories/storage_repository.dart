import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class StorageRepository {
  /// Right when at least [requiredBytes] are free (or free space is unknown).
  Future<Either<Failure, Unit>> ensureFreeSpace(int requiredBytes);
}
