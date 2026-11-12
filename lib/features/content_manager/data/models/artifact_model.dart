import '../../domain/entities/artifact_info.dart';
import 'artifact_part_model.dart';

/// Used for both the LLM (`model`) and the `embedding` entry of the manifest.
class ArtifactModel extends ArtifactInfo {
  const ArtifactModel({
    required super.id,
    required super.version,
    required super.fileName,
    required super.totalSize,
    required super.sha256,
    required super.parts,
  });

  factory ArtifactModel.fromJson(Map<String, dynamic> json) {
    final parts = (json['parts'] as List)
        .map((p) => ArtifactPartModel.fromJson(p as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.index.compareTo(b.index));
    return ArtifactModel(
      id: json['id'] as String,
      version: json['version'] as int,
      fileName: json['fileName'] as String,
      totalSize: json['totalSize'] as int,
      sha256: json['sha256'] as String,
      parts: parts,
    );
  }
}
