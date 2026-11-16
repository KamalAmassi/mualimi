import '../entities/pending_question.dart';
import '../repositories/pending_question_repository.dart';

class GetPendingQuestionsUseCase {
  GetPendingQuestionsUseCase(this._repository);
  final PendingQuestionRepository _repository;

  Future<List<PendingQuestion>> call() => _repository.pendingOldestFirst();
}
