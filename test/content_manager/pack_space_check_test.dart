import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/core/services/device_capability_service.dart';
import 'package:mualimi/core/services/device_info_source.dart';
import 'package:mualimi/core/services/device_snapshot.dart';
import 'package:mualimi/features/content_manager/data/repositories/storage_repository_impl.dart';
import 'package:mualimi/features/content_manager/domain/entities/artifact_info.dart';
import 'package:mualimi/features/content_manager/domain/entities/artifact_kind.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_phase.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_progress.dart';
import 'package:mualimi/features/content_manager/domain/entities/model_source_kind.dart';
import 'package:mualimi/features/content_manager/domain/entities/pack_info.dart';
import 'package:mualimi/features/content_manager/domain/repositories/artifact_repository.dart';
import 'package:mualimi/features/content_manager/domain/usecases/download_artifacts_usecase.dart';
import 'package:mualimi/features/content_manager/domain/usecases/download_params.dart';

const _mb = 1024 * 1024;

class _FixedFreeSpace implements DeviceInfoSource {
  _FixedFreeSpace(this.free);
  final int? free;

  @override
  Future<DeviceSnapshot> read() async => DeviceSnapshot(freeDiskBytes: free);
}

class _RecordingArtifacts extends Fake implements ArtifactRepository {
  int downloads = 0;

  @override
  Stream<DownloadProgress> download(
    ArtifactInfo artifact,
    ArtifactKind kind, {
    ModelSourceKind source = ModelSourceKind.network,
    String? localPath,
  }) async* {
    downloads++;
    yield DownloadProgress(
      phase: DownloadPhase.completed,
      bytesDone: artifact.totalSize,
      totalBytes: artifact.totalSize,
    );
  }
}

PackInfo _pack(int size) => PackInfo(
      grade: 9,
      track: null,
      version: 1,
      url: 'https://example.test/pack.zip',
      mirrors: const [],
      size: size,
      sha256: 'abc',
      subjects: const [],
    );

StorageRepositoryImpl _storage(int? free) =>
    StorageRepositoryImpl(DeviceCapabilityService(source: _FixedFreeSpace(free)));

void main() {
  group('PackInfo.requiredFreeBytes', () {
    test('margin is 20 MB', () {
      expect(PackInfo.spaceMarginBytes, 20 * _mb);
    });

    test('an empty pack needs only the margin', () {
      expect(_pack(0).requiredFreeBytes, 20 * _mb);
    });

    test('a normal pack needs twice its size plus the margin', () {
      expect(_pack(500 * _mb).requiredFreeBytes, 1000 * _mb + 20 * _mb);
    });

    test('pack download params use it', () {
      final pack = _pack(300 * _mb);
      expect(DownloadParams.pack(pack).requiredBytes, pack.requiredFreeBytes);
    });
  });

  group('StorageRepositoryImpl.ensureFreeSpace', () {
    final required = _pack(400 * _mb).requiredFreeBytes;

    test('rejects when free space is below the requirement', () async {
      final result = await _storage(required - 1).ensureFreeSpace(required);
      expect(
        result.fold((f) => f, (_) => null),
        NotEnoughSpaceFailure(requiredBytes: required, freeBytes: required - 1),
      );
    });

    test('accepts when free space equals the requirement', () async {
      expect((await _storage(required).ensureFreeSpace(required)).isRight(), isTrue);
    });

    test('accepts when free space exceeds the requirement', () async {
      expect((await _storage(required + 1).ensureFreeSpace(required)).isRight(), isTrue);
    });

    test('accepts when free space is unknown', () async {
      expect((await _storage(null).ensureFreeSpace(required)).isRight(), isTrue);
    });
  });

  group('DownloadArtifactsUseCase pack space check', () {
    final pack = _pack(400 * _mb);
    final threshold = 2 * pack.size + 20 * _mb;

    test('fails without downloading when free < 2 x size + margin', () async {
      final artifacts = _RecordingArtifacts();
      final useCase = DownloadArtifactsUseCase(artifacts, _storage(threshold - 1));

      final events = await useCase(DownloadParams.pack(pack)).toList();

      expect(events, hasLength(1));
      expect(events.single.phase, DownloadPhase.failed);
      expect(events.single.failure, isA<NotEnoughSpaceFailure>());
      expect(artifacts.downloads, 0);
    });

    test('downloads when free == 2 x size + margin', () async {
      final artifacts = _RecordingArtifacts();
      final useCase = DownloadArtifactsUseCase(artifacts, _storage(threshold));

      final events = await useCase(DownloadParams.pack(pack)).toList();

      expect(artifacts.downloads, 1);
      expect(events.last.phase, DownloadPhase.completed);
    });
  });
}
