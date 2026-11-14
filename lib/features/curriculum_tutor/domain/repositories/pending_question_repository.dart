import '../entities/pending_question.dart';

abstract class PendingQuestionRepository {
  Future<int> enqueue(PendingQuestion question);

  /// Questions still waiting for an answer, oldest first.
  Future<List<PendingQuestion>> pendingOldestFirst();

  Future<void> markAnswered(int id);

  /// Counts a failed attempt and marks the question failed after the last allowed one.
  Future<void> recordFailedAttempt(int id);

  Future<void> delete(int id);
}
