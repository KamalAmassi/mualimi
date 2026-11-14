import 'package:drift/drift.dart';

import '../../../../core/db/user/user_database.dart';
import '../../domain/entities/question_history_item.dart';
import 'answer_source_mapper.dart';

class QuestionHistoryLocalDataSource {
  QuestionHistoryLocalDataSource(this._db);
  final UserDatabase _db;

  Future<int> add(QuestionHistoryItem item) {
    final source = item.source;
    return _db.into(_db.questionHistory).insert(QuestionHistoryCompanion.insert(
          subjectId: source?.subjectId ?? '',
          subjectName: Value(source?.subjectName ?? ''),
          lessonId: Value(source?.lessonId),
          lessonTitle: Value(source?.lessonTitle),
          question: item.question,
          answer: Value(item.answer),
          printedPage: Value(source?.printedPage),
          pdfPage: Value(source?.pdfPage),
          fromBank: Value(item.fromBank),
        ));
  }

  Future<QuestionHistoryItem?> byId(int id) async {
    final row = await (_db.select(_db.questionHistory)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _item(row);
  }

  Future<List<QuestionHistoryItem>> recent({required int limit}) async {
    final rows = await (_db.select(_db.questionHistory)
          ..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
            (t) => OrderingTerm.desc(t.id)
          ])
          ..limit(limit))
        .get();
    return rows.map(_item).toList();
  }

  Future<void> clear() => _db.delete(_db.questionHistory).go();

  QuestionHistoryItem _item(QuestionHistoryRow r) => QuestionHistoryItem(
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
      );
}
