import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mualimi/app.dart';
import 'package:mualimi/core/bindings/initial_binding.dart';
import 'package:mualimi/core/constants/app_files.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/core/services/app_paths_service.dart';
import 'package:mualimi/core/services/database_service.dart';
import 'package:mualimi/core/services/device_info_source.dart';
import 'package:mualimi/core/services/device_snapshot.dart';
import 'package:mualimi/core/services/settings_service.dart';
import 'package:mualimi/core/usecase/usecase.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_phase.dart';
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
import 'package:mualimi/features/onboarding/presentation/controllers/splash_timing.dart';

class _WifiConnectivity extends Fake implements Connectivity {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => [ConnectivityResult.wifi];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => const Stream.empty();
}

class _RoomyDevice implements DeviceInfoSource {
  @override
  Future<DeviceSnapshot> read() async =>
      const DeviceSnapshot(ramBytes: 8 << 30, freeDiskBytes: 100 << 30);
}

PackInfo _pack(int grade) => PackInfo(
      grade: grade,
      track: null,
      version: 1,
      url: 'https://example.test/pack-$grade.zip',
      mirrors: const [],
      size: 100,
      sha256: 'sha',
      subjects: const [],
    );

class _FakeManifest extends Fake implements GetManifestUseCase {
  @override
  Future<Either<Failure, Manifest>> call(NoParams params) async =>
      Right(Manifest(schemaVersion: 1, packs: [_pack(9)]));
}

class _FakeCheckUpdate extends Fake implements CheckPackUpdateUseCase {
  @override
  Future<Either<Failure, PackInfo?>> call(int grade) async => const Right(null);
}

class _FakePause extends Fake implements PauseDownloadUseCase {
  @override
  Future<bool> call() async => true;
}

class _FakeResume extends Fake implements ResumeDownloadUseCase {
  @override
  Future<bool> call() async => true;
}

class _FakeCancel extends Fake implements CancelDownloadUseCase {
  @override
  Future<void> call() async {}
}

/// Stands in for the network and the installer: each job emits [script], and
/// a completed job installs the development pack as a real install would.
class ScriptedDownload extends Fake implements DownloadArtifactsUseCase {
  ScriptedDownload(this.script);

  List<DownloadProgress> script;
  int jobs = 0;

  @override
  Stream<DownloadProgress> call(DownloadParams params) async* {
    jobs++;
    for (final p in script) {
      if (p.phase == DownloadPhase.completed) await _installDevPack();
      yield p;
    }
  }

  Future<void> _installDevPack() async {
    final paths = Get.find<AppPathsService>();
    final settings = Get.find<SettingsService>();
    final databases = Get.find<DatabaseService>();
    final db = ContentDatabase(NativeDatabase(paths.contentDbFile));
    await DevSeedScienceG9.insert(db);
    await db.close();
    databases.openContent();
    await settings.setInstalledPackVersion(1);
  }
}

const completedScript = [
  DownloadProgress(phase: DownloadPhase.downloading, bytesDone: 50, totalBytes: 100),
  DownloadProgress(phase: DownloadPhase.completed, bytesDone: 100, totalBytes: 100),
];

const noSpaceScript = [
  DownloadProgress(
    phase: DownloadPhase.failed,
    failure: NotEnoughSpaceFailure(requiredBytes: 1, freeBytes: 0),
  ),
];

const failedScript = [
  DownloadProgress(phase: DownloadPhase.failed, failure: NetworkFailure()),
];

const pausedScript = [
  DownloadProgress(phase: DownloadPhase.downloading, bytesDone: 20, totalBytes: 100),
  DownloadProgress(phase: DownloadPhase.paused, bytesDone: 20, totalBytes: 100),
];

/// Real app, bindings and routes on temp storage; only the network-facing
/// download use cases are faked.
class Journey {
  Journey(this.tester, this.root, this.download);

  final WidgetTester tester;
  final Directory root;
  final ScriptedDownload download;

  /// Drift's isolates and file IO don't advance under fake async, so each
  /// step alternates real waiting with pumping.
  Future<void> settle({int rounds = 12}) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 40)));
      await tester.pump(const Duration(milliseconds: 40));
    }
  }

  Future<void> boot({bool devSeed = false}) async {
    Get.put<DownloadArtifactsUseCase>(download);
    Get.put<GetManifestUseCase>(_FakeManifest());
    Get.put<CheckPackUpdateUseCase>(_FakeCheckUpdate());
    Get.put<PauseDownloadUseCase>(_FakePause());
    Get.put<ResumeDownloadUseCase>(_FakeResume());
    Get.put<CancelDownloadUseCase>(_FakeCancel());
    final binding = await tester.runAsync(() => InitialBinding.create(
          rootOverride: root,
          connectivityPlugin: _WifiConnectivity(),
          deviceInfo: _RoomyDevice(),
          installDevSeed: devSeed,
        ));
    await tester.pumpWidget(MualimiApp(initialBinding: binding!));
    await tester.pump(SplashTiming.minDisplay);
    await settle();
  }

  Future<void> installReturningStudent() async {
    final packs = Directory('${root.path}/${AppFiles.packsDir}')..createSync(recursive: true);
    final seed = ContentDatabase(NativeDatabase(File('${packs.path}/${AppFiles.contentDb}')));
    await tester.runAsync(() async {
      await DevSeedScienceG9.insert(seed);
      await seed.close();
    });
    File('${root.path}/${AppFiles.settingsFile}').writeAsStringSync(jsonEncode({
      'onboarding_done': true,
      'installed_pack_version': 1,
      'grade': 9,
      'student_name': 'سلمى',
    }));
  }

  Future<void> tapText(String text, {bool last = false}) async {
    final finder = last ? find.text(text).last : find.text(text);
    await tester.tap(finder);
    await settle();
  }

  /// Taps whichever back control the current page shows.
  Future<void> back() async {
    final candidates = [
      find.byType(BackButton),
      find.byIcon(Icons.close),
      find.byIcon(LucideIcons.arrowRight),
      find.byIcon(Icons.chevron_right),
    ];
    final target = candidates.firstWhere((f) => f.evaluate().isNotEmpty).first;
    await tester.tap(target);
    await settle();
  }

  /// True when no page lies under the current one.
  bool get atStackRoot => !Get.key.currentState!.canPop();
}

void journeyTest(
  String name,
  Future<void> Function(Journey j) body, {
  List<DownloadProgress> script = completedScript,
  String? skip,
}) {
  testWidgets(name, skip: skip != null, (tester) async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final root = (await tester.runAsync(() => Directory.systemTemp.createTemp('journey')))!;
    addTearDown(() async {
      Get.reset();
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        try {
          await root.delete(recursive: true);
        } on FileSystemException {
          // Drift's isolate may still hold the file on Windows.
        }
      });
    });
    await body(Journey(tester, root, ScriptedDownload(script)));
  });
}
