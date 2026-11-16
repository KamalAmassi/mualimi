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

  /// Never throws: every failure becomes a [Left], after trying the cache.
  @override
  Future<Either<Failure, Manifest>> getManifest() async {
    final Map<String, dynamic> json;
    final ManifestModel manifest;
    try {
      json = await _remote.fetch();
      manifest = ManifestModel.fromJson(json);
    } on NetworkException catch (e) {
      return _fromCache(NetworkFailure(e.message));
    } on ManifestException catch (e) {
      return _fromCache(ManifestFailure(e.message));
    } catch (e) {
      return _fromCache(ManifestFailure('unexpected manifest error: $e'));
    }
    await _writeCache(json); // only a parsed, valid manifest becomes the cache
    return Right(manifest);
  }

  /// A failed cache write must not fail a successful fetch.
  Future<void> _writeCache(Map<String, dynamic> json) async {
    try {
      await _local.write(json);
    } catch (_) {
      // The next successful fetch will try again.
    }
  }

  Future<Either<Failure, Manifest>> _fromCache(Failure remoteFailure) async {
    try {
      final cached = await _local.read();
      if (cached == null) return Left(remoteFailure);
      return Right(ManifestModel.fromJson(cached));
    } catch (_) {
      return Left(remoteFailure);
    }
  }
}
