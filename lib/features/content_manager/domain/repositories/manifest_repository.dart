import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/manifest.dart';

abstract class ManifestRepository {
  /// Fetches from the server; falls back to the cached copy when offline.
  Future<Either<Failure, Manifest>> getManifest();
}
