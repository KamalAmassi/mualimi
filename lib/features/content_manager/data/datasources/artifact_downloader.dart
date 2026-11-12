import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../../../../core/constants/app_files.dart';
import '../../../../core/constants/limits.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/file_parts_util.dart';
import '../../../../core/utils/sha256_util.dart';
import '../../domain/entities/artifact_info.dart';
import '../../domain/entities/artifact_part.dart';
import '../../domain/entities/download_phase.dart';
import '../../domain/entities/download_progress.dart';
import 'part_downloader.dart';

/// Downloads an artifact part by part: resume, per-part SHA-256, mirror
/// fallback, re-download of only a corrupt part, isolate assembly, and a
/// final whole-file check.
class ArtifactDownloader {
  ArtifactDownloader(this._parts);

  final PartDownloader _parts;
  StreamController<DownloadProgress>? _out;
  bool _canceled = false;
  int _totalBytes = 0;
  int _lastBytes = 0;

  Stream<DownloadProgress> run(
    ArtifactInfo artifact, {
    required File target,
    required Directory partsDir,
  }) {
    final out = StreamController<DownloadProgress>();
    _out = out;
    _canceled = false;
    _totalBytes = artifact.totalSize;
    _lastBytes = 0;
    unawaited(_run(artifact, target, partsDir).whenComplete(out.close));
    return out.stream;
  }

  Future<bool> pause() async {
    final ok = await _parts.pause();
    if (ok) _emit(DownloadPhase.paused, _lastBytes);
    return ok;
  }

  Future<bool> resume() async {
    final ok = await _parts.resume();
    if (ok) _emit(DownloadPhase.downloading, _lastBytes);
    return ok;
  }

  Future<void> cancel() async {
    _canceled = true;
    await _parts.cancel();
  }

  Future<void> _run(ArtifactInfo a, File target, Directory partsDir) async {
    try {
      if (a.parts.isEmpty) {
        _fail(const ManifestFailure('artifact has no parts'));
        return;
      }
      await partsDir.create(recursive: true);
      var done = 0;
      for (final part in a.parts) {
        final file = File(p.join(partsDir.path, '${a.fileName}${AppFiles.partSuffix}${part.index}'));
        // A verified part from an earlier run is kept: this is cross-restart resume.
        if (await Sha256Util.verifyFile(file, part.sha256)) {
          done += part.size;
          _emit(DownloadPhase.downloading, done);
          continue;
        }
        if (!await _fetchVerified(part, file, done)) return;
        done += part.size;
      }
      await _assemble(a, target, partsDir);
    } on FileSystemException catch (e) {
      _fail(StorageFailure(e.message));
    } catch (e) {
      _fail(NetworkFailure(e.toString()));
    }
  }

  /// Downloads one part until its checksum matches; false if the job ended.
  Future<bool> _fetchVerified(ArtifactPart part, File file, int doneBefore) async {
    for (var attempt = 0; attempt < Limits.maxPartRedownloads; attempt++) {
      final result = await _fetchFromAnyUrl(part, file, doneBefore);
      if (_canceled || result == PartResult.canceled) {
        _emit(DownloadPhase.canceled, _lastBytes);
        return false;
      }
      if (result == PartResult.failed) {
        _fail(const NetworkFailure('all sources failed'));
        return false;
      }
      _emit(DownloadPhase.verifying, doneBefore + part.size);
      if (await Sha256Util.verifyFile(file, part.sha256)) return true;
      if (await file.exists()) await file.delete(); // only this part is retried
    }
    _fail(IntegrityFailure('part ${part.index} is corrupt'));
    return false;
  }

  /// Tries each mirror in order, always from the original URL.
  Future<PartResult> _fetchFromAnyUrl(ArtifactPart part, File file, int doneBefore) async {
    for (var i = 0; i < Limits.maxUrlAttemptsPerPart * part.urls.length; i++) {
      final result = await _parts.download(
        url: part.urls[i % part.urls.length],
        dest: file,
        onProgress: (f) => _emit(DownloadPhase.downloading, doneBefore + (f * part.size).round()),
      );
      if (result != PartResult.failed) return result;
      if (await file.exists()) await file.delete();
    }
    return PartResult.failed;
  }

  Future<void> _assemble(ArtifactInfo a, File target, Directory partsDir) async {
    _emit(DownloadPhase.assembling, _totalBytes);
    final paths = [
      for (final part in a.parts)
        p.join(partsDir.path, '${a.fileName}${AppFiles.partSuffix}${part.index}'),
    ];
    await FilePartsUtil.assemble(paths, target.path);
    _emit(DownloadPhase.verifying, _totalBytes);
    if (!await Sha256Util.verifyFile(target, a.sha256)) {
      await target.delete();
      _fail(const IntegrityFailure('assembled file failed its checksum'));
      return;
    }
    if (await partsDir.exists()) await partsDir.delete(recursive: true);
    _emit(DownloadPhase.completed, _totalBytes);
  }

  void _emit(DownloadPhase phase, int bytes) {
    _lastBytes = bytes;
    _out?.add(DownloadProgress(phase: phase, bytesDone: bytes, totalBytes: _totalBytes));
  }

  void _fail(Failure failure) {
    _out?.add(DownloadProgress(
      phase: DownloadPhase.failed,
      bytesDone: _lastBytes,
      totalBytes: _totalBytes,
      failure: failure,
    ));
  }
}
