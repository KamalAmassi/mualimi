import 'package:drift/drift.dart';

import '../../../../core/db/user/user_database.dart';
import 'download_task_store.dart';

/// Mirrors per-artifact download progress into user.db, and remembers the
/// background task id of each part (row `artifact:partIndex`) so a
/// restarted app resumes it.
class DownloadStateLocalDataSource implements DownloadTaskStore {
  DownloadStateLocalDataSource(this._db);
  final UserDatabase _db;

  Future<void> save({
    required String artifact,
    required String status,
    required int bytes,
    required int total,
  }) {
    return _db.into(_db.downloadsState).insertOnConflictUpdate(
          DownloadsStateCompanion.insert(
            id: '$artifact:0',
            artifact: artifact,
            partIndex: 0,
            status: status,
            bytesDownloaded: Value(bytes),
            totalBytes: Value(total),
          ),
        );
  }

  Future<void> clear(String artifact) =>
      (_db.delete(_db.downloadsState)..where((t) => t.artifact.equals(artifact))).go();

  @override
  Future<Map<int, String>> taskIds(String artifact) async {
    final rows = await (_db.select(_db.downloadsState)
          ..where((t) => t.artifact.equals(artifact) & t.taskId.isNotNull()))
        .get();
    return {for (final r in rows) r.partIndex: r.taskId!};
  }

  /// Only the task id is updated on an existing row: the status written by
  /// [save] is kept.
  @override
  Future<void> saveTaskId(String artifact, int partIndex, String taskId) {
    return _db.into(_db.downloadsState).insert(
          DownloadsStateCompanion.insert(
            id: '$artifact:$partIndex',
            artifact: artifact,
            partIndex: partIndex,
            status: 'downloading',
            taskId: Value(taskId),
          ),
          onConflict: DoUpdate((_) => DownloadsStateCompanion(
                taskId: Value(taskId),
                updatedAt: Value(DateTime.now()),
              )),
        );
  }

  @override
  Future<void> removePart(String artifact, int partIndex) =>
      (_db.delete(_db.downloadsState)..where((t) => t.id.equals('$artifact:$partIndex'))).go();
}
