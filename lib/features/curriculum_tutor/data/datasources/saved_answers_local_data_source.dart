import 'package:drift/drift.dart';

import '../../../../core/db/user/user_database.dart';
import '../../domain/entities/saved_answer.dart';

class SavedAnswersLocalDataSource {
  SavedAnswersLocalDataSource(this._db);
  final UserDatabase _db;

  Future<void> save(SavedAnswer a) {
    return _db.into(_db.savedAnswers).insert(SavedAnswersCompanion.insert(
          subjectId: a.subjectId,
          lessonId: Value(a.lessonId),
          question: a.question,
          answer: a.answer,
          sourcePage: Value(a.sourcePage),
        ));
  }

  Future<List<SavedAnswer>> all() async {
    final rows = await (_db.select(_db.savedAnswers)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return [
      for (final r in rows)
        SavedAnswer(
          id: r.id,
          subjectId: r.subjectId,
          lessonId: r.lessonId,
          question: r.question,
          answer: r.answer,
          sourcePage: r.sourcePage,
          createdAt: r.createdAt,
        ),
    ];
  }

  Future<void> delete(int id) =>
      (_db.delete(_db.savedAnswers)..where((t) => t.id.equals(id))).go();
}
