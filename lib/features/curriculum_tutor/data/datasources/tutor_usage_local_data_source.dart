import 'package:drift/drift.dart';

import '../../../../core/db/user/user_database.dart';

typedef Clock = DateTime Function();

/// Per-day count of questions sent to the cloud tutor (`tutor_usage`).
class TutorUsageLocalDataSource {
  TutorUsageLocalDataSource(this._db, {Clock? clock})
      : _clock = clock ?? DateTime.now;

  final UserDatabase _db;
  final Clock _clock;

  Future<int> countToday() async {
    final row = await (_db.select(_db.tutorUsage)
          ..where((t) => t.day.equals(_today())))
        .getSingleOrNull();
    return row?.count ?? 0;
  }

  Future<void> increment() => _db.customInsert(
        'INSERT INTO tutor_usage (day, count) VALUES (?, 1) '
        'ON CONFLICT(day) DO UPDATE SET count = count + 1',
        variables: [Variable.withString(_today())],
        updates: {_db.tutorUsage},
      );

  String _today() {
    final now = _clock();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }
}
