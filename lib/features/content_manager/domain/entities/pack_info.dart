import 'package:equatable/equatable.dart';

import 'artifact_info.dart';
import 'artifact_part.dart';
import 'subject_info.dart';

/// A grade's content pack: a single zip with content.db and the book PDFs.
class PackInfo extends Equatable {
  const PackInfo({
    required this.grade,
    required this.track,
    required this.version,
    required this.url,
    required this.mirrors,
    required this.size,
    required this.sha256,
    required this.subjects,
  });

  final int grade;
  final String? track;
  final int version;
  final String url;
  final List<String> mirrors;
  final int size;
  final String sha256;
  final List<SubjectInfo> subjects;

  /// Packs download through the same engine as models, as a one-part artifact.
  ArtifactInfo get asArtifact => ArtifactInfo(
        id: 'pack-$grade${track == null ? '' : '-$track'}',
        version: version,
        fileName: 'pack-$grade-v$version.zip',
        totalSize: size,
        sha256: sha256,
        parts: [
          ArtifactPart(index: 0, urls: [url, ...mirrors], size: size, sha256: sha256),
        ],
      );

  @override
  List<Object?> get props => [grade, track, version, url, mirrors, size, sha256, subjects];
}
