import '../../../../core/error/exceptions.dart';
import '../../domain/entities/manifest.dart';
import 'artifact_model.dart';
import 'pack_model.dart';

class ManifestModel extends Manifest {
  const ManifestModel({
    required super.schemaVersion,
    required super.packs,
    super.model,
    super.embedding,
  });

  static const supportedSchemaVersion = 1;

  /// Throws [ManifestException] for any malformed or unsupported document.
  factory ManifestModel.fromJson(Map<String, dynamic> json) {
    try {
      final version = json['schemaVersion'] as int;
      if (version != supportedSchemaVersion) {
        throw ManifestException('unsupported schemaVersion $version');
      }
      final model = json['model'] as Map<String, dynamic>?;
      final embedding = json['embedding'] as Map<String, dynamic>?;
      return ManifestModel(
        schemaVersion: version,
        packs: (json['packs'] as List)
            .map((p) => PackModel.fromJson(p as Map<String, dynamic>))
            .toList(),
        model: model == null ? null : ArtifactModel.fromJson(model),
        embedding: embedding == null ? null : ArtifactModel.fromJson(embedding),
      );
    } on ManifestException {
      rethrow;
    } on TypeError catch (e) {
      throw ManifestException('bad field type: $e');
    } on FormatException catch (e) {
      throw ManifestException(e.message);
    }
  }
}
