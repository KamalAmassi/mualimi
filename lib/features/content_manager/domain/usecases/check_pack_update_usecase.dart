import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/pack_info.dart';
import '../repositories/installed_content_repository.dart';
import '../repositories/manifest_repository.dart';

/// Right(null) means the installed pack is current (or none is offered).
class CheckPackUpdateUseCase implements UseCase<PackInfo?, int> {
  CheckPackUpdateUseCase(this._manifests, this._installed);
  final ManifestRepository _manifests;
  final InstalledContentRepository _installed;

  @override
  Future<Either<Failure, PackInfo?>> call(int grade) async {
    final result = await _manifests.getManifest();
    final installed = await _installed.installedPackVersion();
    return result.map((m) {
      final offered = m.packFor(grade);
      if (offered == null || installed == null) return null;
      return offered.version > installed ? offered : null;
    });
  }
}
