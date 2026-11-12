import '../../../../core/constants/limits.dart';
import '../entities/question_history_item.dart';
import '../repositories/question_history_repository.dart';

class GetQuestionHistoryUseCase {
  GetQuestionHistoryUseCase(this._repository);
  final QuestionHistoryRepository _repository;

  Future<List<QuestionHistoryItem>> call() => _repository.recent(limit: Limits.historyMax);
}
