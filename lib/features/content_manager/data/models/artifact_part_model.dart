import '../../domain/entities/artifact_part.dart';

class ArtifactPartModel extends ArtifactPart {
  const ArtifactPartModel({
    required super.index,
    required super.urls,
    required super.size,
    required super.sha256,
  });

  factory ArtifactPartModel.fromJson(Map<String, dynamic> json) {
    final urls = (json['urls'] as List).cast<String>();
    if (urls.isEmpty) throw const FormatException('part has no urls');
    return ArtifactPartModel(
      index: json['index'] as int,
      urls: urls,
      size: json['size'] as int,
      sha256: json['sha256'] as String,
    );
  }
}
