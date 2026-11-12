import 'package:drift/drift.dart';

import '../../../../core/db/content/content_database.dart';
import '../../../../core/error/exceptions.dart' as app;
import '../../../../core/services/database_service.dart';
import '../../domain/entities/subject_unit.dart';
import '../models/lesson_summary_model.dart';
import '../models/subject_model.dart';

class SubjectsLocalDataSource {
  SubjectsLocalDataSource(this._databases);
  final DatabaseService _databases;

  Future<List<SubjectModel>> subjects() async {
    final db = _content();
    final rows = await (db.select(db.subjects)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
    return rows.map(SubjectModel.fromRow).toList();
  }

  Future<SubjectModel> subject(String id) async {
    final db = _content();
    final row = await (db.select(db.subjects)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) throw app.DatabaseException('subject $id not found');
    return SubjectModel.fromRow(row);
  }

  Future<List<SubjectUnit>> units(String subjectId) async {
    final db = _content();
    final units = await (db.select(db.units)
          ..where((t) => t.subjectId.equals(subjectId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    final lessons = await (db.select(db.lessons)
          ..where((t) => t.subjectId.equals(subjectId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    return [
      for (final u in units)
        SubjectUnit(
          id: u.id,
          title: u.title,
          lessons: [
            for (final l in lessons)
              if (l.unitId == u.id) LessonSummaryModel.fromRow(l),
          ],
        ),
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
