import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/error/exceptions.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/features/content_manager/data/datasources/manifest_local_data_source.dart';
import 'package:mualimi/features/content_manager/data/datasources/manifest_remote_data_source.dart';
import 'package:mualimi/features/content_manager/data/repositories/manifest_repository_impl.dart';

Map<String, dynamic> manifestJson(int version) => {
      'schemaVersion': 1,
      'packs': [
        {
          'grade': 9, 'track': null, 'version': version,
          'url': 'https://a/pack.zip', 'mirrors': <String>[],
          'size': 10, 'sha256': 'abc', 'subjects': <dynamic>[],
        },
      ],
    };

class _FakeRemote implements ManifestRemoteDataSource {
  _FakeRemote({this.json, this.error});
  final Map<String, dynamic>? json;
  final Object? error;

  @override
  Future<Map<String, dynamic>> fetch() async {
    if (error != null) throw error!;
    return json!;
  }
}

class _FakeLocal implements ManifestLocalDataSource {
  _FakeLocal([this.cached]);
  Map<String, dynamic>? cached;
  int writes = 0;

  @override
  Future<Map<String, dynamic>?> read() async => cached;

  @override
  Future<void> write(Map<String, dynamic> json) async {
    writes++;
    cached = json;
  }
}

int packVersion(dynamic result) =>
    result.getOrElse(() => throw StateError('expected Right')).packs.single.version as int;

void main() {
  test('success returns Right and updates the cache', () async {
    final local = _FakeLocal(manifestJson(1));
    final repo = ManifestRepositoryImpl(_FakeRemote(json: manifestJson(2)), local);
    final result = await repo.getManifest();
    expect(packVersion(result), 2);
    expect(local.writes, 1);
    expect(local.cached, manifestJson(2));
  });

  test('network failure with a cache returns the cached manifest', () async {
    final local = _FakeLocal(manifestJson(1));
    final repo = ManifestRepositoryImpl(
        _FakeRemote(error: const NetworkException('offline')), local);
    expect(packVersion(await repo.getManifest()), 1);
    expect(local.writes, 0);
  });

  test('bad remote manifest with a cache returns cache and keeps it intact', () async {
    final local = _FakeLocal(manifestJson(1));
    final bad = {'schemaVersion': 99, 'packs': <dynamic>[]};
    final repo = ManifestRepositoryImpl(_FakeRemote(json: bad), local);
    expect(packVersion(await repo.getManifest()), 1);
    expect(local.writes, 0);
    expect(local.cached, manifestJson(1));
  });

  test('remote ManifestException with a cache returns the cache', () async {
    final local = _FakeLocal(manifestJson(1));
    final repo = ManifestRepositoryImpl(
        _FakeRemote(error: const ManifestException('bad json')), local);
    expect(packVersion(await repo.getManifest()), 1);
    expect(local.writes, 0);
  });

  test('network failure without a cache returns Left(NetworkFailure)', () async {
    final repo = ManifestRepositoryImpl(
        _FakeRemote(error: const NetworkException('offline')), _FakeLocal());
    expect((await repo.getManifest()).swap().getOrElse(() => throw StateError('')),
        const NetworkFailure('offline'));
  });

  test('bad manifest without a cache returns Left(ManifestFailure)', () async {
    final repo = ManifestRepositoryImpl(
        _FakeRemote(error: const ManifestException('bad json')), _FakeLocal());
    expect((await repo.getManifest()).swap().getOrElse(() => throw StateError('')),
        const ManifestFailure('bad json'));
  });

  test('an unexpected exception becomes Left, never escapes', () async {
    final repo = ManifestRepositoryImpl(
        _FakeRemote(error: const FileSystemException('boom')), _FakeLocal());
    final result = await repo.getManifest();
    expect(result.isLeft(), isTrue);
    result.fold((f) => expect(f, isA<ManifestFailure>()), (_) => fail('expected Left'));
  });
}
