import 'dart:io';

import '../../../../core/error/failures.dart';
import '../../../../core/services/app_paths_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../domain/entities/artifact_info.dart';
import '../../domain/entities/artifact_kind.dart';
import '../../domain/entities/download_phase.dart';
import '../../domain/entities/download_progress.dart';
import '../../domain/entities/model_source_kind.dart';
import '../../domain/repositories/artifact_repository.dart';
import '../datasources/download_state_local_data_source.dart';
import '../datasources/model_source.dart';
import '../datasources/pack_installer.dart';

typedef ModelSourceFactory = ModelSource Function(ModelSourceKind kind, String? localPath);

class ArtifactRepositoryImpl implements ArtifactRepository {
  ArtifactRepositoryImpl({
    required AppPathsService paths,
    required SettingsService settings,
    required PackInstaller installer,
    required DownloadStateLocalDataSource states,
    required ModelSourceFactory sourceFor,
  })  : _paths = paths,
        _settings = settings,
        _installer = installer,
        _states = states,
        _sourceFor = sourceFor;

  final AppPathsService _paths;
  final SettingsService _settings;
  final PackInstaller _installer;
  final DownloadStateLocalDataSource _states;
  final ModelSourceFactory _sourceFor;
  ModelSource? _active;

  @override
  Stream<DownloadProgress> download(
    ArtifactInfo artifact,
    ArtifactKind kind, {
    ModelSourceKind source = ModelSourceKind.network,
    String? localPath,
  }) async* {
    final target = kind == ArtifactKind.pack
        ? File('${_paths.packsDir.path}${Platform.pathSeparator}${artifact.fileName}')
        : _paths.modelFile(artifact.fileName);
    final active = _active = _sourceFor(source, localPath);
    var lastPhase = DownloadPhase.paused;

    await for (final p in active.acquire(artifact, target: target, partsDir: _paths.partsDirOf(artifact.id))) {
      if (p.phase != lastPhase) {
        lastPhase = p.phase;
        await _states.save(
          artifact: artifact.id,
          status: p.phase.name,
          bytes: p.bytesDone,
          total: p.totalBytes,
        );
      }
      if (p.phase != DownloadPhase.completed) {
        yield p;
        continue;
      }
      // "Completed" is only true once the file is registered.
      try {
        await _register(artifact, kind);
        await _states.clear(artifact.id);
        yield p;
      } catch (e) {
        yield DownloadProgress(
          phase: DownloadPhase.failed,
          bytesDone: p.bytesDone,
          totalBytes: p.totalBytes,
          failure: StorageFailure(e.toString()),
        );
      }
    }
    _active = null;
  }

  Future<void> _register(ArtifactInfo artifact, ArtifactKind kind) {
    switch (kind) {
      case ArtifactKind.pack:
        final zip = File('${_paths.packsDir.path}${Platform.pathSeparator}${artifact.fileName}');
        return _installer.install(zip, artifact.version);
      case ArtifactKind.model:
        return _settings.setInstalledModelFile(artifact.fileName);
      case ArtifactKind.embedding:
        return _settings.setInstalledEmbeddingFile(artifact.fileName);
    }
  }

  @override
  Future<bool> pause() async => await _active?.pause() ?? false;

  @override
  Future<bool> resume() async => await _active?.resume() ?? false;

  @override
  Future<void> cancel() async => _active?.cancel();
}
