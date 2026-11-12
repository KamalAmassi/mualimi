import '../../../../core/constants/limits.dart';
import '../entities/artifact_info.dart';
import '../entities/artifact_kind.dart';
import '../entities/model_source_kind.dart';
import '../entities/pack_info.dart';

/// What to download, in order, and how much free space that needs.
class DownloadParams {
  const DownloadParams._(this.items, this.requiredBytes, this.source, this.localPath);

  /// A content pack: the zip plus its extracted copy must fit at once.
  factory DownloadParams.pack(PackInfo pack) => DownloadParams._(
        [(pack.asArtifact, ArtifactKind.pack)],
        pack.size * 2 + Limits.downloadMarginBytes,
        ModelSourceKind.network,
        null,
      );

  /// The LLM and (optionally) the embedding model, downloaded back to back.
  factory DownloadParams.model(
    ArtifactInfo model, {
    ArtifactInfo? embedding,
    ModelSourceKind source = ModelSourceKind.network,
    String? localPath,
  }) {
    final artifacts = [model, if (embedding != null) embedding];
    final total = artifacts.fold<int>(0, (s, a) => s + a.totalSize);
    // Importing a file has no parts, so no largest-part allowance.
    final headroom = source == ModelSourceKind.network ? model.largestPartSize : 0;
    return DownloadParams._(
      [(model, ArtifactKind.model), if (embedding != null) (embedding, ArtifactKind.embedding)],
      total + headroom + Limits.downloadMarginBytes,
      source,
      localPath,
    );
  }

  final List<(ArtifactInfo, ArtifactKind)> items;
  final int requiredBytes;
  final ModelSourceKind source;
  final String? localPath;

  int get totalBytes => items.fold(0, (s, i) => s + i.$1.totalSize);
}
