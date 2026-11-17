import '../../../../core/services/database_service.dart';

/// Reads the subject's tutor flag from content.db.
class SubjectTutorLocalDataSource {
  SubjectTutorLocalDataSource(this._databases);
  final DatabaseService _databases;

  /// Throws [StateError] when no pack is installed.
  Future<bool> isTutorEnabled(String subjectId) async {
    final db = _databases.content;
    final subject =
        await (db.select(db.subjects)..where((t) => t.id.equals(subjectId))).getSingleOrNull();
    return subject?.tutorEnabled ?? false;
  }
}
