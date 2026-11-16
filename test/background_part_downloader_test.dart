import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/content_manager/data/datasources/background_part_downloader.dart';
import 'package:mualimi/features/content_manager/data/datasources/engine_task_info.dart';
import 'package:mualimi/features/content_manager/data/datasources/part_downloader.dart';

import 'helpers/fake_download_engine.dart';

void main() {
  const id = 'pack-v3-p0-m0';
  const url = 'https://a/0';
  late Directory dir;
  late File dest;
  late FakeDownloadEngine engine;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('bpd_test');
    dest = File('${dir.path}/parts/pack.zip.part0');
    engine = FakeDownloadEngine();
  });

  tearDown(() => dir.delete(recursive: true));

  /// Starts a download on a fresh downloader (a new "app run") and lets the
  /// engine's transfer finish with [result].
  Future<PartResult> runOnce({PartResult result = PartResult.complete}) async {
    final future = BackgroundPartDownloader(engine: engine)
        .download(taskId: id, url: url, dest: dest, onProgress: (_) {});
    while (engine.transfers[id]?.listening != true) {
      await Future<void>.delayed(const Duration(milliseconds: 1));
    }
    engine.transfers[id]!.finish(result);
    return future;
  }

  void remember(EngineTaskStatus status, {required bool alive, String taskUrl = url}) =>
      engine.known[id] = EngineTaskInfo(url: taskUrl, status: status, alive: alive);

  test('an unknown task starts fresh and the destination is not deleted first', () async {
    await dest.parent.create(recursive: true);
    await dest.writeAsBytes([1, 2, 3]);
    expect(await runOnce(), PartResult.complete);
    expect(engine.started, [id]);
    expect(engine.destExistedAtStart, [isTrue]);
  });

  test('after a restart the killed task is resumed, not started again', () async {
    await runOnce(result: PartResult.failed);
    remember(EngineTaskStatus.active, alive: false); // the app was killed mid-download
    expect(await runOnce(), PartResult.complete);
    expect(engine.started, [id]);
    expect(engine.attached, [id]);
    expect(engine.transfers[id]!.resumeCalls, 1);
  });

  test('a still-running task with the same id is adopted, not duplicated', () async {
    remember(EngineTaskStatus.active, alive: true);
    expect(await runOnce(), PartResult.complete);
    expect(engine.started, isEmpty);
    expect(engine.attached, [id]);
    expect(engine.transfers[id]!.resumeCalls, 0);
  });

  test('a paused or failed task is resumed', () async {
    for (final status in [EngineTaskStatus.paused, EngineTaskStatus.failed]) {
      engine = FakeDownloadEngine();
      remember(status, alive: status == EngineTaskStatus.paused);
      expect(await runOnce(), PartResult.complete);
      expect(engine.started, isEmpty);
      expect(engine.transfers[id]!.resumeCalls, 1);
    }
  });

  test('a completed task (file removed after a hash mismatch) restarts cleanly', () async {
    remember(EngineTaskStatus.complete, alive: false);
    expect(await runOnce(), PartResult.complete);
    expect(engine.forgotten, [id]);
    expect(engine.started, [id]);
  });

  test('a known task with another URL is never resumed', () async {
    remember(EngineTaskStatus.paused, alive: true, taskUrl: 'https://old/0');
    await runOnce();
    expect(engine.forgotten, [id]);
    expect(engine.started, [id]);
    expect(engine.attached, isEmpty);
  });

  test('canResume and forget go through the engine', () async {
    final downloader = BackgroundPartDownloader(engine: engine);
    engine.resumable.add(id);
    expect(await downloader.canResume(id), isTrue);
    expect(await downloader.canResume('other'), isFalse);
    await downloader.forget(id);
    expect(engine.forgotten, [id]);
  });
}
