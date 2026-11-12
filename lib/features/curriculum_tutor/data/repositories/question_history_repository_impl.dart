import '../../domain/entities/question_history_item.dart';
import '../../domain/repositories/question_history_repository.dart';
import '../datasources/question_history_local_data_source.dart';

class QuestionHistoryRepositoryImpl implements QuestionHistoryRepository {
  QuestionHistoryRepositoryImpl(this._local);
  final QuestionHistoryLocalDataSource _local;

  @override
  Future<void> add(QuestionHistoryItem item) => _local.add(item);

  @override
  Future<List<QuestionHistoryItem>> recent({required int limit}) => _local.recent(limit: limit);

  @override
  Future<void> clear() => _local.clear();
}
