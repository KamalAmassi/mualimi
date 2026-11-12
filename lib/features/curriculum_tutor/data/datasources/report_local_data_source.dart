import 'package:drift/drift.dart';

import '../../../../core/db/user/user_database.dart';
import '../../domain/entities/pending_report.dart';

class ReportLocalDataSource {
  ReportLocalDataSource(this._db);
  final UserDatabase _db;

  Future<void> add(PendingReport r) {
    return _db.into(_db.pendingReports).insert(PendingReportsCompanion.insert(
          lessonId: Value(r.lessonId),
          question: r.question,
          answer: r.answer,
          reason: r.reason,
          note: Value(r.note),
        ));
  }

  Future<List<PendingReport>> all() async {
    final rows = await _db.select(_db.pendingReports).get();
    return [
      for (final r in rows)
        PendingReport(
          id: r.id,
          lessonId: r.lessonId,
          question: r.question,
          answer: r.answer,
          reason: r.reason,
          note: r.note,
        ),
    ];
  }

  Future<void> remove(int id) =>
      (_db.delete(_db.pendingReports)..where((t) => t.id.equals(id))).go();
}
