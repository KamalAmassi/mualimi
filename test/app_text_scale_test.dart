import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/app.dart';
import 'package:mualimi/core/bindings/initial_binding.dart';
import 'package:mualimi/core/constants/app_files.dart';
import 'package:mualimi/core/services/device_info_source.dart';
import 'package:mualimi/core/services/device_snapshot.dart';
import 'package:mualimi/features/onboarding/presentation/controllers/splash_timing.dart';

class _OfflineConnectivity extends Fake implements Connectivity {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => [ConnectivityResult.none];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => const Stream.empty();
}

class _RoomyDevice implements DeviceInfoSource {
  @override
  Future<DeviceSnapshot> read() async =>
      const DeviceSnapshot(ramBytes: 8 << 30, freeDiskBytes: 100 << 30);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late Directory root;

  setUp(() async => root = await Directory.systemTemp.createTemp('text_scale'));

  tearDown(() async {
    Get.reset();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    try {
      await root.delete(recursive: true);
    } on FileSystemException {
      // Drift's isolate may still hold the file on Windows; the OS temp dir is cleaned later.
    }
  });

  testWidgets('the app keeps the device text scale and ignores the reading factor',
      (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    File('${root.path}/${AppFiles.settingsFile}')
      ..createSync(recursive: true)
      ..writeAsStringSync(jsonEncode({'font_scale': 1.15}));

    final binding = await tester.runAsync(() => InitialBinding.create(
          rootOverride: root,
          connectivityPlugin: _OfflineConnectivity(),
          deviceInfo: _RoomyDevice(),
        ));
    expect(binding!.settings.fontScale.value, 1.15);
    await tester.pumpWidget(MualimiApp(initialBinding: binding));
    await tester.pump(SplashTiming.minDisplay);
    for (var i = 0; i < 12; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 40)));
      await tester.pump(const Duration(milliseconds: 40));
    }

    final screen = tester.element(find.byType(Scaffold).last);
    expect(MediaQuery.textScalerOf(screen).scale(10), closeTo(13, 0.001));
  });
}
