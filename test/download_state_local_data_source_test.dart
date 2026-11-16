import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/user/user_database.dart';
import 'package:mualimi/features/content_manager/data/datasources/download_state_local_data_source.dart';

void main() {
  late UserDatabase db;

  setUp(() => db = UserDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('task ids are written, survive a restart, and are cleared on success', () async {
    await DownloadStateLocalDataSource(db).saveTaskId('pack', 0, 'pack-v3-p0-m0');
    await DownloadStateLocalDataSource(db).saveTaskId('pack', 1, 'pack-v3-p1-m1');

    // A new data source over the same user.db = the app after a restart.
    final restarted = DownloadStateLocalDataSource(db);
    expect(await restarted.taskIds('pack'), {0: 'pack-v3-p0-m0', 1: 'pack-v3-p1-m1'});

    await restarted.clear('pack');
    expect(await restarted.taskIds('pack'), isEmpty);
  });

  test('phase saves keep the task id, and task id saves keep the phase', () async {
    final states = DownloadStateLocalDataSource(db);
    await states.save(artifact: 'pack', status: 'paused', bytes: 10, total: 20);
    await states.saveTaskId('pack', 0, 'pack-v3-p0-m1');
    await states.save(artifact: 'pack', status: 'downloading', bytes: 15, total: 20);

    expect(await states.taskIds('pack'), {0: 'pack-v3-p0-m1'});
    final row = await db.select(db.downloadsState).getSingle();
    expect(row.status, 'downloading');
    expect(row.bytesDownloaded, 15);
  });

  test('removePart drops only that part', () async {
    final states = DownloadStateLocalDataSource(db);
    await states.saveTaskId('pack', 0, 'a');
    await states.saveTaskId('pack', 1, 'b');
    await states.removePart('pack', 0);
    expect(await states.taskIds('pack'), {1: 'b'});
  });
}
