import '../entities/question_history_item.dart';

abstract class QuestionHistoryRepository {
  Future<void> add(QuestionHistoryItem item);
  Future<List<QuestionHistoryItem>> recent({required int limit});
  Future<void> clear();
}
