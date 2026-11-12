import 'package:drift/drift.dart';

import '../../../../core/db/user/user_database.dart';

/// Mirrors per-artifact download progress into user.db.
class DownloadStateLocalDataSource {
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
}
