import 'dart:io';

import '../../domain/entities/artifact_info.dart';
import '../../domain/entities/download_progress.dart';

/// Where a large file comes from: the network, a local file, or (later) a peer.
abstract class ModelSource {
  /// Produces the verified final file at [target]. [partsDir] is scratch space.
  Stream<DownloadProgress> acquire(
    ArtifactInfo artifact, {
    required File target,
    required Directory partsDir,
  });

  Future<bool> pause();
  Future<bool> resume();
  Future<void> cancel();
}
