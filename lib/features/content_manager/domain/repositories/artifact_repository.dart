import '../entities/artifact_info.dart';
import '../entities/artifact_kind.dart';
import '../entities/download_progress.dart';
import '../entities/model_source_kind.dart';

abstract class ArtifactRepository {
  /// Acquires [artifact] (parts, checksums, assembly, registration) and
  /// reports progress. Failures arrive as a final `failed` event.
  Stream<DownloadProgress> download(
    ArtifactInfo artifact,
    ArtifactKind kind, {
    ModelSourceKind source = ModelSourceKind.network,
    String? localPath,
  });

  Future<bool> pause();
  Future<bool> resume();
  Future<void> cancel();
}
