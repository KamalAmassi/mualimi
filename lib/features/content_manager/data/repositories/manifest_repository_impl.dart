import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/manifest.dart';
import '../../domain/repositories/manifest_repository.dart';
import '../datasources/manifest_local_data_source.dart';
import '../datasources/manifest_remote_data_source.dart';
import '../models/manifest_model.dart';

class ManifestRepositoryImpl implements ManifestRepository {
  ManifestRepositoryImpl(this._remote, this._local);

  final ManifestRemoteDataSource _remote;
  final ManifestLocalDataSource _local;

  @override
  Future<Either<Failure, Manifest>> getManifest() async {
    try {
      final json = await _remote.fetch();
      final manifest = ManifestModel.fromJson(json);
      await _local.write(json); // only a parsed, valid manifest becomes the cache
      return Right(manifest);
    } on NetworkException catch (e) {
      return _fromCache(NetworkFailure(e.message));
    } on ManifestException catch (e) {
      return Left(ManifestFailure(e.message));
    }
  }

  Future<Either<Failure, Manifest>> _fromCache(Failure networkFailure) async {
    try {
      final cached = await _local.read();
      if (cached == null) return Left(networkFailure);
      return Right(ManifestModel.fromJson(cached));
    } on ManifestException {
      return Left(networkFailure);
    }
  }
}
