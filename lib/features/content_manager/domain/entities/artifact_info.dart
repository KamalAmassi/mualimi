import 'dart:math';

import 'package:equatable/equatable.dart';

import '../../../../core/constants/limits.dart';
import 'artifact_part.dart';

/// A downloadable file: the LLM, the embedding model, or a content pack.
class ArtifactInfo extends Equatable {
  const ArtifactInfo({
    required this.id,
    required this.version,
    required this.fileName,
    required this.totalSize,
    required this.sha256,
    required this.parts,
  });

  final String id;
  final int version;
  final String fileName;
  final int totalSize;
  final String sha256;
  final List<ArtifactPart> parts;

  int get largestPartSize => parts.fold(0, (m, p) => max(m, p.size));

  /// Parts and the assembled file coexist briefly, so we need the file plus
  /// the largest part plus a margin.
  int get requiredFreeBytes => totalSize + largestPartSize + Limits.downloadMarginBytes;

  @override
  List<Object?> get props => [id, version, fileName, totalSize, sha256, parts];
}
