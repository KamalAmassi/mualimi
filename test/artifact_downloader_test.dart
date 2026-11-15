import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/core/utils/sha256_util.dart';
import 'package:mualimi/features/content_manager/data/datasources/artifact_downloader.dart';
import 'package:mualimi/features/content_manager/data/datasources/isolate_hash_verifier.dart';
import 'package:mualimi/features/content_manager/data/datasources/part_downloader.dart';
import 'package:mualimi/features/content_manager/domain/entities/artifact_info.dart';
import 'package:mualimi/features/content_manager/domain/entities/artifact_part.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_phase.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_progress.dart';

/// Serves bytes by URL. `failUrls` always fail; `corruptOnce` serves wrong
/// bytes the first time that URL is requested.
class _FakePartDownloader implements PartDownloader {
  _FakePartDownloader(this.content);

  final Map<String, Uint8List> content;
  final failUrls = <String>{};
  final corruptOnce = <String>{};
  final corruptAlways = <String>{};
  final requests = <String>[];
  final taskIds = <String>[];
  final forgotten = <String>[];
  final existedAtStart = <bool>[];

  @override
  Future<PartResult> download({
    required String taskId,
    required String url,
    required File dest,
    required void Function(double fraction) onProgress,
  }) async {
    requests.add(url);
    taskIds.add(taskId);
    existedAtStart.add(dest.existsSync());
    if (failUrls.contains(url)) return PartResult.failed;
    var bytes = content[url]!;
    if (corruptAlways.contains(url) || corruptOnce.remove(url)) {
      bytes = Uint8List.fromList(bytes.map((b) => b ^ 0xFF).toList());
    }
    await dest.writeAsBytes(bytes);
    onProgress(1);
    return PartResult.complete;
  }

  @override
  Future<bool> canResume(String taskId) async => false;
  @override
  Future<void> forget(String taskId) async => forgotten.add(taskId);
  @override
  Future<bool> pause() async => false;
  @override
  Future<bool> resume() async => false;
  @override
  Future<void> cancel() async {}
}

void main() {
  late Directory dir;
  late Uint8List full;
  late List<Uint8List> slices;
  late _FakePartDownloader fake;
  late ArtifactInfo artifact;
  late File target;
  late Directory partsDir;

  ArtifactInfo build({String? fullSha}) => ArtifactInfo(
        id: 'model',
        version: 1,
        fileName: 'm.bin',
        totalSize: full.length,
        sha256: fullSha ?? Sha256Util.ofBytes(full),
        parts: [
          for (var i = 0; i < slices.length; i++)
            ArtifactPart(
              index: i,
              urls: ['https://a/$i', 'https://b/$i'],
              size: slices[i].length,
              sha256: Sha256Util.ofBytes(slices[i]),
            ),
        ],
      );

  /// Paths actually hashed (existing files), via the real isolate verifier.
  late List<String> hashed;

  Future<bool> countingVerify(String path, String expectedHex) async {
    if (File(path).existsSync()) hashed.add(path);
    return IsolateHashVerifier.verify(path, expectedHex);
  }

  Future<List<DownloadProgress>> run() => ArtifactDownloader(fake, verify: countingVerify)
      .run(artifact, target: target, partsDir: partsDir)
      .toList();

  void useSinglePart() {
    slices = [full];
    fake.content
      ..['https://a/0'] = full
      ..['https://b/0'] = full;
    artifact = build();
  }

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('dl_test');
    hashed = [];
    full = Uint8List.fromList(List.generate(1500, (i) => i % 251));
    slices = [full.sublist(0, 500), full.sublist(500, 1000), full.sublist(1000)];
    fake = _FakePartDownloader({
      for (var i = 0; i < 3; i++) ...{'https://a/$i': slices[i], 'https://b/$i': slices[i]},
    });
    artifact = build();
    target = File('${dir.path}/out/m.bin');
    await target.parent.create();
    partsDir = Directory('${dir.path}/parts');
  });

  tearDown(() => dir.delete(recursive: true));

  test('downloads, assembles and verifies the full file', () async {
    final events = await run();
    expect(events.last.phase, DownloadPhase.completed);
    expect(await target.readAsBytes(), full);
    expect(partsDir.existsSync(), isFalse);
    expect(fake.requests, hasLength(3));
  });

  test('falls back to the next URL when one fails', () async {
    fake.failUrls.add('https://a/1');
    final events = await run();
    expect(events.last.phase, DownloadPhase.completed);
    expect(fake.requests.where((u) => u.endsWith('/1')), contains('https://b/1'));
  });

  test('a corrupt part is re-downloaded alone', () async {
    fake.corruptOnce.add('https://a/1');
    final events = await run();
    expect(events.last.phase, DownloadPhase.completed);
    expect(fake.requests.where((u) => u.endsWith('/0')), hasLength(1));
    expect(fake.requests.where((u) => u.endsWith('/1')), hasLength(2));
    expect(fake.requests.where((u) => u.endsWith('/2')), hasLength(1));
  });

  test('a corrupt part is deleted after the hash mismatch and its tasks forgotten', () async {
    fake.corruptOnce.add('https://a/1');
    final events = await run();
    expect(events.last.phase, DownloadPhase.completed);
    expect(fake.forgotten, containsAll(['model-v1-p1-m0', 'model-v1-p1-m1']));
    // The retry runs after the corrupt file was removed.
    expect(fake.existedAtStart, everyElement(isFalse));
  });

  test('a corrupt part left by an earlier run is deleted, then re-downloaded', () async {
    await partsDir.create();
    await File('${partsDir.path}/m.bin.part0').writeAsBytes([9, 9, 9]);
    final events = await run();
    expect(events.last.phase, DownloadPhase.completed);
    expect(fake.existedAtStart.first, isFalse);
    expect(await target.readAsBytes(), full);
  });

  test('uses one deterministic task id per part and mirror', () async {
    fake.failUrls.add('https://a/1');
    await run();
    expect(fake.taskIds.where((id) => id.contains('-p1-')).take(2),
        ['model-v1-p1-m0', 'model-v1-p1-m1']);
    expect(fake.taskIds.first, 'model-v1-p0-m0');
  });

  test('a verified part left by an earlier run is not downloaded again', () async {
    await partsDir.create();
    await File('${partsDir.path}/m.bin.part0').writeAsBytes(slices[0]);
    final events = await run();
    expect(events.last.phase, DownloadPhase.completed);
    expect(fake.requests.where((u) => u.endsWith('/0')), isEmpty);
  });

  test('fails with NetworkFailure when every source fails', () async {
    fake.failUrls.addAll(['https://a/0', 'https://b/0']);
    final last = (await run()).last;
    expect(last.phase, DownloadPhase.failed);
    expect(last.failure, isA<NetworkFailure>());
  });

  test('fails with IntegrityFailure when a part stays corrupt', () async {
    fake.corruptAlways.addAll(['https://a/2', 'https://b/2']);
    final last = (await run()).last;
    expect(last.failure, isA<IntegrityFailure>());
  });

  test('a wrong whole-file checksum fails and leaves no output file', () async {
    artifact = build(fullSha: 'deadbeef');
    final last = (await run()).last;
    expect(last.phase, DownloadPhase.failed);
    expect(last.failure, isA<IntegrityFailure>());
    expect(target.existsSync(), isFalse);
  });

  test('progress never exceeds the total and reaches it', () async {
    final events = await run();
    expect(events.every((e) => e.bytesDone <= e.totalBytes), isTrue);
    expect(events.last.bytesDone, full.length);
  });

  test('multi-part: every part and the assembled file are each hashed once', () async {
    final events = await run();
    expect(events.last.phase, DownloadPhase.completed);
    expect(hashed, hasLength(4));
    expect(hashed.last, target.path);
    expect(events.map((e) => e.phase), contains(DownloadPhase.assembling));
  });

  test('single part: renamed into place and hashed only once', () async {
    useSinglePart();
    final events = await run();
    expect(events.last.phase, DownloadPhase.completed);
    expect(await target.readAsBytes(), full);
    expect(partsDir.existsSync(), isFalse);
    expect(fake.requests, ['https://a/0']);
    expect(hashed, hasLength(1));
    expect(hashed.single, isNot(target.path));
  });

  test('single part: a corrupt download is re-downloaded, then completes', () async {
    useSinglePart();
    fake.corruptOnce.add('https://a/0');
    final events = await run();
    expect(events.last.phase, DownloadPhase.completed);
    expect(await target.readAsBytes(), full);
    expect(fake.requests, hasLength(2));
    expect(hashed, hasLength(2));
  });

  test('single part: a part that stays corrupt fails with IntegrityFailure', () async {
    useSinglePart();
    fake.corruptAlways.addAll(['https://a/0', 'https://b/0']);
    final last = (await run()).last;
    expect(last.phase, DownloadPhase.failed);
    expect(last.failure, isA<IntegrityFailure>());
    expect(target.existsSync(), isFalse);
  });

  test('single part: a different whole-file hash still runs the final check', () async {
    useSinglePart();
    artifact = build(fullSha: 'deadbeef');
    final last = (await run()).last;
    expect(last.failure, isA<IntegrityFailure>());
    expect(hashed, hasLength(2));
    expect(target.existsSync(), isFalse);
  });

  test('single part: a stale output file is replaced', () async {
    useSinglePart();
    await target.writeAsBytes([1, 2, 3]);
    final events = await run();
    expect(events.last.phase, DownloadPhase.completed);
    expect(await target.readAsBytes(), full);
  });
}
