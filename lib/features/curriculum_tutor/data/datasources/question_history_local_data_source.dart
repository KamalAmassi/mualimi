import 'package:drift/drift.dart';

import '../../../../core/db/user/user_database.dart';
import '../../domain/entities/question_history_item.dart';

class QuestionHistoryLocalDataSource {
  QuestionHistoryLocalDataSource(this._db);
  final UserDatabase _db;

  Future<void> add(QuestionHistoryItem item) {
    return _db.into(_db.questionHistory).insert(QuestionHistoryCompanion.insert(
          subjectId: item.subjectId,
          lessonId: Value(item.lessonId),
          question: item.question,
        ));
  }

  Future<List<QuestionHistoryItem>> recent({required int limit}) async {
    final rows = await (_db.select(_db.questionHistory)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt), (t) => OrderingTerm.desc(t.id)])
          ..limit(limit))
        .get();
    return [
      for (final r in rows)
        QuestionHistoryItem(
          id: r.id,
          subjectId: r.subjectId,
          lessonId: r.lessonId,
          question: r.question,
          createdAt: r.createdAt,
        ),
    ];
  }

  Future<void> clear() => _db.delete(_db.questionHistory).go();
}
