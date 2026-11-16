import 'package:drift/drift.dart';

import '../../domain/entities/quick_action.dart';
import 'content_access.dart';

/// Tutor-related reads from content.db: subject gating and prebuilt answers.
class TutorContentLocalDataSource {
  TutorContentLocalDataSource(this._content);
  final ContentAccess _content;

  Future<bool> isTutorEnabled(String subjectId, {String? lessonId}) async {
    final db = _content();
    final subject = await (db.select(db.subjects)
          ..where((t) => t.id.equals(subjectId)))
        .getSingleOrNull();
    if (subject == null || !subject.tutorEnabled) return false;
    if (lessonId == null) return true;
    final lesson = await (db.select(db.lessons)
          ..where((t) => t.id.equals(lessonId)))
        .getSingleOrNull();
    return lesson?.tutorEnabled ?? false;
  }

  Future<String?> prebuiltAnswer(String lessonId, QuickAction action) async {
    final db = _content();
    final row = await (db.select(db.prebuiltAnswers)
          ..where(
              (t) => t.lessonId.equals(lessonId) & t.kind.equals(action.kind))
          ..limit(1))
        .getSingleOrNull();
    return row?.content;
  }
}
