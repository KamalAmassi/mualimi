import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/manifest.dart';
import '../repositories/manifest_repository.dart';

class GetManifestUseCase implements UseCase<Manifest, NoParams> {
  GetManifestUseCase(this._repository);
  final ManifestRepository _repository;

  @override
  Future<Either<Failure, Manifest>> call(NoParams params) => _repository.getManifest();
}
