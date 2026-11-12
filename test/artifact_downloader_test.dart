import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/core/utils/sha256_util.dart';
import 'package:mualimi/features/content_manager/data/datasources/artifact_downloader.dart';
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

  @override
  Future<PartResult> download({
    required String url,
    required File dest,
    required void Function(double fraction) onProgress,
  }) async {
    requests.add(url);
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

  Future<List<DownloadProgress>> run() =>
      ArtifactDownloader(fake).run(artifact, target: target, partsDir: partsDir).toList();

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('dl_test');
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
}
