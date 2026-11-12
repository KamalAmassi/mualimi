import '../repositories/artifact_repository.dart';

class ResumeDownloadUseCase {
  ResumeDownloadUseCase(this._repository);
  final ArtifactRepository _repository;

  Future<bool> call() => _repository.resume();
}
