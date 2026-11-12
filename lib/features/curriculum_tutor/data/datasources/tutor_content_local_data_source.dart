import 'package:drift/drift.dart';

import '../../../../core/db/content/content_database.dart';
import '../../../../core/error/exceptions.dart' as app;
import '../../../../core/services/database_service.dart';
import '../../domain/entities/quick_action.dart';

/// Tutor-related reads from content.db: subject gating and prebuilt answers.
class TutorContentLocalDataSource {
  TutorContentLocalDataSource(this._databases);
  final DatabaseService _databases;

  Future<bool> isTutorEnabled(String subjectId, {String? lessonId}) async {
    final db = _db();
    final subject = await (db.select(db.subjects)..where((t) => t.id.equals(subjectId)))
        .getSingleOrNull();
    if (subject == null || !subject.tutorEnabled) return false;
    if (lessonId == null) return true;
    final lesson = await (db.select(db.lessons)..where((t) => t.id.equals(lessonId)))
        .getSingleOrNull();
    return lesson?.tutorEnabled ?? false;
  }

  Future<String?> prebuiltAnswer(String lessonId, QuickAction action) async {
    final db = _db();
    final row = await (db.select(db.prebuiltAnswers)
          ..where((t) => t.lessonId.equals(lessonId) & t.kind.equals(action.kind))
          ..limit(1))
        .getSingleOrNull();
    return row?.content;
  }

  ContentDatabase _db() {
    try {
      return _databases.content;
    } on StateError catch (e) {
      throw app.DatabaseException(e.message);
    }
  }
}
