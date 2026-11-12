import 'package:equatable/equatable.dart';

/// One ~500 MB slice of a large file, downloadable from several mirrors.
class ArtifactPart extends Equatable {
  const ArtifactPart({
    required this.index,
    required this.urls,
    required this.size,
    required this.sha256,
  });

  final int index;
  final List<String> urls;
  final int size;
  final String sha256;

  @override
  List<Object?> get props => [index, urls, size, sha256];
}
