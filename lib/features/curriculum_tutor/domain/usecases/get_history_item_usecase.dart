import '../entities/question_history_item.dart';
import '../repositories/question_history_repository.dart';

class GetHistoryItemUseCase {
  GetHistoryItemUseCase(this._repository);
  final QuestionHistoryRepository _repository;

  Future<QuestionHistoryItem?> call(int id) => _repository.byId(id);
}
