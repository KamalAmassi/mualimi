import '../repositories/llm_repository.dart';

class StopGenerationUseCase {
  StopGenerationUseCase(this._repository);
  final LlmRepository _repository;

  Future<void> call() => _repository.stop();
}
