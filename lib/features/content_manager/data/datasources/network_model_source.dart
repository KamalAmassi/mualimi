import 'dart:io';

import '../../domain/entities/artifact_info.dart';
import '../../domain/entities/download_progress.dart';
import 'artifact_downloader.dart';
import 'model_source.dart';

class NetworkModelSource implements ModelSource {
  NetworkModelSource(this._downloader);
  final ArtifactDownloader _downloader;

  @override
  Stream<DownloadProgress> acquire(
    ArtifactInfo artifact, {
    required File target,
    required Directory partsDir,
  }) =>
      _downloader.run(artifact, target: target, partsDir: partsDir);

  @override
  Future<bool> pause() => _downloader.pause();

  @override
  Future<bool> resume() => _downloader.resume();

  @override
  Future<void> cancel() => _downloader.cancel();
}
