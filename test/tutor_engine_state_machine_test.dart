import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/services/app_paths_service.dart';
import 'package:mualimi/core/services/device_capability_service.dart';
import 'package:mualimi/core/services/device_info_source.dart';
import 'package:mualimi/core/services/device_snapshot.dart';
import 'package:mualimi/core/services/model_runtime.dart';
import 'package:mualimi/core/services/settings_service.dart';
import 'package:mualimi/core/services/tutor_engine_service.dart';
import 'package:mualimi/core/services/tutor_engine_state.dart';
import 'package:mualimi/core/services/tutor_engine_transitions.dart';

class _FakeInfo implements DeviceInfoSource {
  _FakeInfo(this.ram);
  final int? ram;
  @override
  Future<DeviceSnapshot> read() async => DeviceSnapshot(ramBytes: ram);
}

class _FakeRuntime implements ModelRuntime {
  bool failLoad = false;
  int loads = 0;
  @override
  Future<void> load(String modelPath) async {
    loads++;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (failLoad) throw StateError('boom');
  }

  @override
  Future<void> unload() async {}
}

const _states = <TutorEngineState>[
  NotDownloaded(),
  Downloading(),
  Paused(),
  Verifying(),
  Assembling(),
  Downloaded(),
  Loading(),
  Ready(),
  Failed('x'),
  Unsupported(),
  SearchOnly(),
];

TutorEngineState _of(TutorEngineKind k) => _states.firstWhere((s) => s.kind == k);

void main() {
  group('transition table', () {
    const allowed = <(TutorEngineKind, TutorEngineKind)>[
      (TutorEngineKind.notDownloaded, TutorEngineKind.downloading),
      (TutorEngineKind.downloading, TutorEngineKind.downloading),
      (TutorEngineKind.downloading, TutorEngineKind.paused),
      (TutorEngineKind.paused, TutorEngineKind.downloading),
      (TutorEngineKind.downloading, TutorEngineKind.verifying),
      (TutorEngineKind.verifying, TutorEngineKind.assembling),
      (TutorEngineKind.verifying, TutorEngineKind.downloading),
      (TutorEngineKind.assembling, TutorEngineKind.verifying),
      (TutorEngineKind.verifying, TutorEngineKind.downloaded),
      (TutorEngineKind.assembling, TutorEngineKind.downloaded),
      (TutorEngineKind.downloaded, TutorEngineKind.loading),
      (TutorEngineKind.loading, TutorEngineKind.ready),
      (TutorEngineKind.ready, TutorEngineKind.downloaded),
      (TutorEngineKind.ready, TutorEngineKind.notDownloaded),
      (TutorEngineKind.downloaded, TutorEngineKind.notDownloaded),
      (TutorEngineKind.failed, TutorEngineKind.downloading),
      (TutorEngineKind.notDownloaded, TutorEngineKind.unsupported),
      (TutorEngineKind.unsupported, TutorEngineKind.searchOnly),
      // import from file / model found on disk at startup
      (TutorEngineKind.notDownloaded, TutorEngineKind.verifying),
      (TutorEngineKind.notDownloaded, TutorEngineKind.downloaded),
      // cancel
      (TutorEngineKind.downloading, TutorEngineKind.notDownloaded),
      (TutorEngineKind.paused, TutorEngineKind.notDownloaded),
      // load aborted
      (TutorEngineKind.loading, TutorEngineKind.downloaded),
      // retry after failure
      (TutorEngineKind.failed, TutorEngineKind.notDownloaded),
      (TutorEngineKind.failed, TutorEngineKind.verifying),
      (TutorEngineKind.failed, TutorEngineKind.downloaded),
    ];

    test('allowed transitions pass', () {
      for (final (from, to) in allowed) {
        expect(TutorEngineTransitions.isAllowed(_of(from), _of(to)), isTrue,
            reason: '$from -> $to');
      }
    });

    test('every state can fail, except failed itself', () {
      for (final s in _states) {
        expect(TutorEngineTransitions.isAllowed(s, const Failed('y')),
            s is! Failed, reason: '${s.kind} -> failed');
      }
    });

    test('everything else is forbidden', () {
      final explicit = allowed.toSet();
      for (final from in _states) {
        for (final to in _states) {
          if (to is Failed || explicit.contains((from.kind, to.kind))) continue;
          expect(TutorEngineTransitions.isAllowed(from, to), isFalse,
              reason: '${from.kind} -> ${to.kind} should be forbidden');
        }
      }
    });

    test('model cannot be used without being downloaded and loaded', () {
      expect(TutorEngineTransitions.isAllowed(const NotDownloaded(), const Ready()), isFalse);
      expect(TutorEngineTransitions.isAllowed(const Downloaded(), const Ready()), isFalse);
      expect(TutorEngineTransitions.isAllowed(const SearchOnly(), const Downloading()), isFalse);
    });
  });

  group('TutorEngineService', () {
    late Directory dir;
    late AppPathsService paths;
    late SettingsService settings;
    late _FakeRuntime runtime;

    Future<TutorEngineService> build({int? ram, bool withModel = true}) async {
      dir = await Directory.systemTemp.createTemp('engine_test');
      paths = await AppPathsService(rootOverride: dir).init();
      settings = await SettingsService(paths.settingsFile).init();
      if (withModel) {
        await paths.modelFile('m.litertlm').writeAsString('x');
        await settings.setInstalledModelFile('m.litertlm');
      }
      final device = await DeviceCapabilityService(source: _FakeInfo(ram)).init();
      runtime = _FakeRuntime();
      return TutorEngineService(
              paths: paths, settings: settings, device: device, runtime: runtime)
          .init();
    }

    tearDown(() => dir.delete(recursive: true));

    test('starts downloaded when the file exists, notDownloaded otherwise', () async {
      expect((await build()).state.value, isA<Downloaded>());
      expect((await build(withModel: false)).state.value, isA<NotDownloaded>());
    });

    test('weak device ends in searchOnly and never loads', () async {
      final e = await build(ram: 2 * 1024 * 1024 * 1024);
      expect(e.state.value, isA<SearchOnly>());
      await e.ensureLoaded();
      expect(runtime.loads, 0);
      expect(await e.whenReady(), isFalse);
    });

    test('model is not loaded at init; ensureLoaded loads once', () async {
      final e = await build();
      expect(runtime.loads, 0);
      await Future.wait([e.ensureLoaded(), e.ensureLoaded()]);
      expect(runtime.loads, 1);
      expect(e.state.value, isA<Ready>());
    });

    test('whenReady waits through loading and resolves true', () async {
      final e = await build();
      expect(await e.whenReady(), isTrue);
    });

    test('load failure moves to failed and whenReady resolves false', () async {
      final e = await build();
      runtime.failLoad = true;
      expect(await e.whenReady(), isFalse);
      expect(e.state.value, isA<Failed>());
    });

    test('deleteModel removes the file and returns to notDownloaded', () async {
      final e = await build();
      await e.ensureLoaded();
      expect(await e.deleteModel(), isTrue);
      expect(e.state.value, isA<NotDownloaded>());
      expect(paths.modelFile('m.litertlm').existsSync(), isFalse);
    });

    test('deleteModel refuses mid-load and keeps files', () async {
      final e = await build();
      e.state.value = const Loading();
      expect(await e.deleteModel(), isFalse);
      expect(paths.modelFile('m.litertlm').existsSync(), isTrue);
    });
  });
}
