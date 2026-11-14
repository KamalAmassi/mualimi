import '../../domain/entities/pending_question.dart';
import '../../domain/repositories/pending_question_repository.dart';
import '../datasources/pending_question_local_data_source.dart';

class PendingQuestionRepositoryImpl implements PendingQuestionRepository {
  PendingQuestionRepositoryImpl(this._local);
  final PendingQuestionLocalDataSource _local;

  @override
  Future<int> enqueue(PendingQuestion question) => _local.enqueue(question);

  @override
  Future<List<PendingQuestion>> pendingOldestFirst() =>
      _local.pendingOldestFirst();

  @override
  Future<void> markAnswered(int id) => _local.markAnswered(id);

  @override
  Future<void> recordFailedAttempt(int id) => _local.recordFailedAttempt(id);

  @override
  Future<void> delete(int id) => _local.delete(id);
}
