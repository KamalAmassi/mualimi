import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/core/services/connectivity_service.dart';
import 'package:mualimi/core/services/network_kind.dart';
import 'package:mualimi/core/services/settings_service.dart';
import 'package:mualimi/core/usecase/usecase.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_progress.dart';
import 'package:mualimi/features/content_manager/domain/entities/manifest.dart';
import 'package:mualimi/features/content_manager/domain/entities/pack_info.dart';
import 'package:mualimi/features/content_manager/domain/usecases/cancel_download_usecase.dart';
import 'package:mualimi/features/content_manager/domain/usecases/check_pack_update_usecase.dart';
import 'package:mualimi/features/content_manager/domain/usecases/download_artifacts_usecase.dart';
import 'package:mualimi/features/content_manager/domain/usecases/download_params.dart';
import 'package:mualimi/features/content_manager/domain/usecases/get_manifest_usecase.dart';
import 'package:mualimi/features/content_manager/domain/usecases/pause_download_usecase.dart';
import 'package:mualimi/features/content_manager/domain/usecases/resume_download_usecase.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/pack_download_controller.dart';

PackInfo pack(int grade, {int version = 1}) => PackInfo(
      grade: grade,
      track: null,
      version: version,
      url: 'https://example.test/pack-$grade-v$version.zip',
      mirrors: const [],
      size: 100,
      sha256: 'sha-$grade-$version',
      subjects: const [],
    );

/// Records every job; each job's stream stays open, so the job stays busy.
class FakeDownload extends Fake implements DownloadArtifactsUseCase {
  final jobs = <DownloadParams>[];
  final _controllers = <StreamController<DownloadProgress>>[];

  /// File names of the artifacts each job downloads, e.g. `pack-9-v1.zip`.
  List<String> get files => [for (final j in jobs) j.items.single.$1.fileName];

  @override
  Stream<DownloadProgress> call(DownloadParams params) {
    jobs.add(params);
    final c = StreamController<DownloadProgress>();
    _controllers.add(c);
    return c.stream;
  }

  /// Not awaited: a canceled job's stream never delivers its done event.
  void closeAll() {
    for (final c in _controllers) {
      c.close();
    }
  }
}

class FakeCancel extends Fake implements CancelDownloadUseCase {
  int calls = 0;
  @override
  Future<void> call() async => calls++;
}

class _FakePause extends Fake implements PauseDownloadUseCase {}

class _FakeResume extends Fake implements ResumeDownloadUseCase {}

class _FakeManifest extends Fake implements GetManifestUseCase {
  @override
  Future<Either<Failure, Manifest>> call(NoParams params) async =>
      Right(Manifest(schemaVersion: 1, packs: [pack(9), pack(10)]));
}

/// Always offers v2 of the grade it is asked about.
class _FakeCheckUpdate extends Fake implements CheckPackUpdateUseCase {
  @override
  Future<Either<Failure, PackInfo?>> call(int grade) async => Right(pack(grade, version: 2));
}

class _FakeConnectivity extends Fake implements Connectivity {}

/// Real services and controller wired to fakes, as the bindings would.
class PackDownloadHarness {
  PackDownloadHarness({int grade = 9}) {
    settings.grade.value = grade;
    connectivity.network.value = NetworkKind.wifi;
  }

  final download = FakeDownload();
  final cancel = FakeCancel();
  final settings = SettingsService(File('unused-settings.json'));
  final connectivity = ConnectivityService(connectivity: _FakeConnectivity());
  int created = 0;

  PackDownloadController build({required bool autoStart}) {
    created++;
    return PackDownloadController(
      download: download,
      pause: _FakePause(),
      resume: _FakeResume(),
      cancel: cancel,
      connectivity: connectivity,
      getManifest: _FakeManifest(),
      checkUpdate: _FakeCheckUpdate(),
      settings: settings,
      autoStart: autoStart,
    );
  }
}
