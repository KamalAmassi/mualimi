import '../repositories/pending_question_repository.dart';

class DeletePendingQuestionUseCase {
  DeletePendingQuestionUseCase(this._repository);
  final PendingQuestionRepository _repository;

  Future<void> call(int id) => _repository.delete(id);
}
