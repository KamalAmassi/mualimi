import 'package:drift/drift.dart';

import '../../../../core/db/user/user_database.dart';
import '../../domain/entities/saved_answer.dart';
import 'answer_source_mapper.dart';

class SavedAnswersLocalDataSource {
  SavedAnswersLocalDataSource(this._db);
  final UserDatabase _db;

  Future<void> save(SavedAnswer a) {
    final source = a.source;
    return _db.into(_db.savedAnswers).insert(SavedAnswersCompanion.insert(
          subjectId: source?.subjectId ?? '',
          subjectName: Value(source?.subjectName ?? ''),
          lessonId: Value(source?.lessonId),
          lessonTitle: Value(source?.lessonTitle),
          question: a.question,
          answer: a.answer,
          printedPage: Value(source?.printedPage),
          pdfPage: Value(source?.pdfPage),
          fromBank: Value(a.fromBank),
        ));
  }

  Future<List<SavedAnswer>> all() async {
    final rows = await (_db.select(_db.savedAnswers)
          ..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
            (t) => OrderingTerm.desc(t.id)
          ]))
        .get();
    return [
      for (final r in rows)
        SavedAnswer(
          id: r.id,
          question: r.question,
          answer: r.answer,
          fromBank: r.fromBank,
          createdAt: r.createdAt,
          source: answerSourceFromColumns(
            subjectId: r.subjectId,
            subjectName: r.subjectName,
            lessonId: r.lessonId,
            lessonTitle: r.lessonTitle,
            printedPage: r.printedPage,
            pdfPage: r.pdfPage,
          ),
        ),
    ];
  }

  Future<void> delete(int id) =>
      (_db.delete(_db.savedAnswers)..where((t) => t.id.equals(id))).go();
}
