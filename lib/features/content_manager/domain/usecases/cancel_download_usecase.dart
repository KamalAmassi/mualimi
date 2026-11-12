import '../repositories/artifact_repository.dart';

class CancelDownloadUseCase {
  CancelDownloadUseCase(this._repository);
  final ArtifactRepository _repository;

  Future<void> call() => _repository.cancel();
}
