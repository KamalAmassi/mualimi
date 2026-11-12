import '../repositories/artifact_repository.dart';

class PauseDownloadUseCase {
  PauseDownloadUseCase(this._repository);
  final ArtifactRepository _repository;

  Future<bool> call() => _repository.pause();
}
