import 'dart:async';
import 'dart:io';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/sha256_util.dart';
import '../../domain/entities/artifact_info.dart';
import '../../domain/entities/download_phase.dart';
import '../../domain/entities/download_progress.dart';
import 'model_source.dart';

/// Imports the model from a file the student already has (USB stick, a file
/// shared by a friend). The source is verified before it is copied in.
class LocalFileModelSource implements ModelSource {
  LocalFileModelSource(this._sourcePath);

  final String _sourcePath;
  bool _canceled = false;

  @override
  Stream<DownloadProgress> acquire(
    ArtifactInfo artifact, {
    required File target,
    required Directory partsDir,
  }) async* {
    _canceled = false;
    final total = artifact.totalSize;
    final source = File(_sourcePath);
    DownloadProgress at(DownloadPhase phase, int bytes) =>
        DownloadProgress(phase: phase, bytesDone: bytes, totalBytes: total);
    DownloadProgress fail(Failure f) =>
        DownloadProgress(phase: DownloadPhase.failed, totalBytes: total, failure: f);

    if (!await source.exists()) {
      yield fail(const StorageFailure('source file not found'));
      return;
    }
    yield at(DownloadPhase.verifying, 0);
    if (!await Sha256Util.verifyFile(source, artifact.sha256)) {
      yield fail(const IntegrityFailure('imported file failed its checksum'));
      return;
    }

    await target.parent.create(recursive: true);
    final sink = target.openWrite();
    var copied = 0;
    try {
      await for (final chunk in source.openRead()) {
        if (_canceled) {
          yield at(DownloadPhase.canceled, copied);
          return;
        }
        sink.add(chunk);
        copied += chunk.length;
        yield at(DownloadPhase.assembling, copied);
      }
    } on FileSystemException catch (e) {
      yield fail(StorageFailure(e.message));
      return;
    } finally {
      await sink.close();
      if (_canceled && await target.exists()) await target.delete();
    }
    yield at(DownloadPhase.completed, total);
  }

  // A local copy is quick, so pausing is not supported.
  @override
  Future<bool> pause() async => false;

  @override
  Future<bool> resume() async => false;

  @override
  Future<void> cancel() async => _canceled = true;
}
