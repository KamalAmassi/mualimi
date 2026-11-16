import 'package:drift/drift.dart';

import '../../../../core/constants/limits.dart';
import '../../../../core/db/user/user_database.dart';
import '../../domain/entities/pending_question.dart';

class PendingQuestionLocalDataSource {
  PendingQuestionLocalDataSource(this._db);
  final UserDatabase _db;

  Future<int> enqueue(PendingQuestion q) {
    return _db
        .into(_db.pendingQuestions)
        .insert(PendingQuestionsCompanion.insert(
          question: q.question,
          subjectId: q.subjectId,
          lessonId: Value(q.lessonId),
          chunkIds: q.chunkIds.join(','),
        ));
  }

  Future<List<PendingQuestion>> pendingOldestFirst() async {
    final rows = await (_db.select(_db.pendingQuestions)
          ..where((t) => t.status.equals(PendingStatus.pending.name))
          ..orderBy([
            (t) => OrderingTerm.asc(t.createdAt),
            (t) => OrderingTerm.asc(t.id)
          ]))
        .get();
    return [
      for (final r in rows)
        PendingQuestion(
          id: r.id,
          question: r.question,
          subjectId: r.subjectId,
          lessonId: r.lessonId,
          chunkIds: [
            for (final id in r.chunkIds.split(','))
              if (int.tryParse(id) != null) int.parse(id),
          ],
          attempts: r.attempts,
          createdAt: r.createdAt,
        ),
    ];
  }

  Future<void> markAnswered(int id) =>
      (_db.update(_db.pendingQuestions)..where((t) => t.id.equals(id)))
          .write(PendingQuestionsCompanion(
        status: Value(PendingStatus.answered.name),
        answeredAt: Value(DateTime.now()),
      ));

  Future<void> recordFailedAttempt(int id) async {
    await _db.customUpdate(
      'UPDATE pending_questions SET attempts = attempts + 1, '
      'status = CASE WHEN attempts + 1 >= ? THEN ? ELSE status END WHERE id = ?',
      variables: [
        Variable.withInt(Limits.maxPendingAttempts),
        Variable.withString(PendingStatus.failed.name),
        Variable.withInt(id),
      ],
      updates: {_db.pendingQuestions},
    );
  }

  Future<void> delete(int id) =>
      (_db.delete(_db.pendingQuestions)..where((t) => t.id.equals(id))).go();
}
