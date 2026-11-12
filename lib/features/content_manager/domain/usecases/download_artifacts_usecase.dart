import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/download_phase.dart';
import '../entities/artifact_kind.dart';
import '../entities/download_progress.dart';
import '../entities/model_source_kind.dart';
import '../repositories/artifact_repository.dart';
import '../repositories/storage_repository.dart';
import 'download_params.dart';

/// Checks space, then downloads each artifact in order with one combined
/// progress. Serves both pack downloads and model downloads.
class DownloadArtifactsUseCase implements StreamUseCase<DownloadProgress, DownloadParams> {
  DownloadArtifactsUseCase(this._artifacts, this._storage);
  final ArtifactRepository _artifacts;
  final StorageRepository _storage;

  @override
  Stream<DownloadProgress> call(DownloadParams params) async* {
    final space = await _storage.ensureFreeSpace(params.requiredBytes);
    final failure = space.fold<Failure?>((f) => f, (_) => null);
    if (failure != null) {
      yield DownloadProgress(phase: DownloadPhase.failed, failure: failure);
      return;
    }

    final total = params.totalBytes;
    var offset = 0;
    for (final (artifact, kind) in params.items) {
      // A local file can only stand in for the model, never the embedding.
      final fromFile = kind == ArtifactKind.model && params.source == ModelSourceKind.localFile;
      await for (final p in _artifacts.download(
        artifact,
        kind,
        source: fromFile ? ModelSourceKind.localFile : ModelSourceKind.network,
        localPath: fromFile ? params.localPath : null,
      )) {
        final isLast = offset + artifact.totalSize >= total;
        // An intermediate artifact finishing is not the end of the whole job.
        final phase = p.phase == DownloadPhase.completed && !isLast
            ? DownloadPhase.downloading
            : p.phase;
        yield DownloadProgress(
          phase: phase,
          bytesDone: offset + p.bytesDone,
          totalBytes: total,
          failure: p.failure,
        );
        if (p.phase == DownloadPhase.failed || p.phase == DownloadPhase.canceled) return;
      }
      offset += artifact.totalSize;
    }
  }
}
