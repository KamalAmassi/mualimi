import 'package:equatable/equatable.dart';

import 'artifact_info.dart';
import 'pack_info.dart';

class Manifest extends Equatable {
  const Manifest({
    required this.schemaVersion,
    required this.packs,
    this.model,
    this.embedding,
  });

  final int schemaVersion;
  final List<PackInfo> packs;
  final ArtifactInfo? model;
  final ArtifactInfo? embedding;

  PackInfo? packFor(int grade, {String? track}) {
    for (final p in packs) {
      if (p.grade == grade && p.track == track) return p;
    }
    return null;
  }

  @override
  List<Object?> get props => [schemaVersion, packs, model, embedding];
}
