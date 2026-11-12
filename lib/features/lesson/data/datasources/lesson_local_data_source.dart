import 'package:drift/drift.dart';

import '../../../../core/db/content/content_database.dart';
import '../../../../core/error/exceptions.dart' as app;
import '../../../../core/services/database_service.dart';
import '../../domain/entities/book_solution.dart';
import '../../domain/entities/key_term.dart';
import '../models/lesson_model.dart';

/// Read-only lesson content from content.db.
class LessonLocalDataSource {
  LessonLocalDataSource(this._databases);
  final DatabaseService _databases;

  Future<LessonModel> lesson(String id) async {
    final db = _content();
    final row = await (db.select(db.lessons)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) throw app.DatabaseException('lesson $id not found');
    final sections = await (db.select(db.sections)
          ..where((t) => t.lessonId.equals(id))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    return LessonModel.fromRows(row, sections);
  }

  Future<List<KeyTerm>> keyTerms(String lessonId) async {
    final db = _content();
    final rows = await (db.select(db.keyTerms)..where((t) => t.lessonId.equals(lessonId))).get();
    return [for (final r in rows) KeyTerm(term: r.term, definition: r.definition)];
  }

  Future<List<BookSolution>> solutions(String lessonId) async {
    final db = _content();
    final rows = await (db.select(db.bookSolutions)
          ..where((t) => t.lessonId.equals(lessonId))
          ..orderBy([(t) => OrderingTerm.asc(t.number)]))
        .get();
    return [
      for (final r in rows) BookSolution(number: r.number, page: r.page, solution: r.solution),
    ];
  }

  ContentDatabase _content() {
    try {
      return _databases.content;
    } on StateError catch (e) {
      throw app.DatabaseException(e.message);
    }
  }
}
