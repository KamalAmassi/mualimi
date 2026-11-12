import 'package:drift/drift.dart';

import '../../../../core/db/user/user_database.dart';

/// Reading position, stored in user.db so pack updates never erase it.
class LessonProgressLocalDataSource {
  LessonProgressLocalDataSource(this._db);
  final UserDatabase _db;

  Future<int> lastSection(String lessonId) async {
    final row = await (_db.select(_db.lessonProgress)..where((t) => t.lessonId.equals(lessonId)))
        .getSingleOrNull();
    return row?.lastSection ?? 0;
  }

  Future<void> save(String lessonId, int section) {
    return _db.into(_db.lessonProgress).insertOnConflictUpdate(
          LessonProgressCompanion.insert(
            lessonId: lessonId,
            lastSection: Value(section),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }
}
