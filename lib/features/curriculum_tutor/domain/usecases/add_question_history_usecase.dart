import '../entities/question_history_item.dart';
import '../repositories/question_history_repository.dart';

class AddQuestionHistoryUseCase {
  AddQuestionHistoryUseCase(this._repository);
  final QuestionHistoryRepository _repository;

  Future<void> call(QuestionHistoryItem item) => _repository.add(item);
}
