import '../entities/question_history_item.dart';

abstract class QuestionHistoryRepository {
  /// Stores the item and returns its id.
  Future<int> add(QuestionHistoryItem item);
  Future<QuestionHistoryItem?> byId(int id);
  Future<List<QuestionHistoryItem>> recent({required int limit});
  Future<void> clear();
}
