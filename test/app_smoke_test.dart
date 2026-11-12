import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/app.dart';
import 'package:mualimi/core/bindings/initial_binding.dart';
import 'package:mualimi/core/constants/app_files.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/db/content/content_seed.dart';
import 'package:mualimi/core/services/device_info_source.dart';
import 'package:mualimi/core/services/device_snapshot.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/gemma_bootstrap.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/gemma_runtime.dart';

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

/// Drift's background isolates and real file IO don't advance under fake
/// async, so each step alternates real waiting with pumping.
Future<void> settle(WidgetTester tester, {int rounds = 12}) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 40)));
    await tester.pump(const Duration(milliseconds: 40));
  }
}

Future<void> boot(WidgetTester tester, Directory root) async {
  final binding = await tester.runAsync(() => InitialBinding.create(
        runtime: GemmaRuntime(GemmaBootstrap()),
        rootOverride: root,
        connectivityPlugin: _WifiConnectivity(),
        deviceInfo: _RoomyDevice(),
      ));
  await tester.pumpWidget(MualimiApp(initialBinding: binding!));
  await settle(tester);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late Directory root;

  setUp(() async => root = await Directory.systemTemp.createTemp('smoke'));

  tearDown(() async {
    Get.reset();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    try {
      await root.delete(recursive: true);
    } on FileSystemException {
      // Drift's isolate may still hold the file on Windows; the OS temp dir is cleaned later.
    }
  });

  testWidgets('first run walks splash -> welcome -> grade -> download', (tester) async {
    await boot(tester, root);
    expect(find.byType(TextField), findsOneWidget, reason: 'splash should go to welcome');

    await tester.enterText(find.byType(TextField), 'سلمى');
    await tester.tap(find.text(AppStrings.next));
    await settle(tester, rounds: 12); // let the route animation finish
    expect(find.text('${AppStrings.gradePrefix} 9'), findsOneWidget);

    await tester.tap(find.text('${AppStrings.gradePrefix} 9'));
    await tester.pump();
    // The welcome page is still in the stack under the grade page.
    await tester.tap(find.text(AppStrings.next).last);
    await settle(tester);

    // The test HTTP client refuses every request, so the manifest can't load:
    // the download screen must land on its failed state, not crash.
    expect(find.text(AppStrings.downloadFailed), findsOneWidget);
    expect(find.text(AppStrings.retry), findsOneWidget);
  });

  testWidgets('an empty name is rejected on the welcome screen', (tester) async {
    await boot(tester, root);
    await tester.tap(find.text(AppStrings.next));
    await settle(tester, rounds: 3);
    expect(find.text(AppStrings.studentNameInvalid), findsOneWidget);
  });

  testWidgets('returning student: splash -> shell -> subject -> lesson -> tutor tab', (tester) async {
    // An installed pack plus finished onboarding.
    final packs = Directory('${root.path}/${AppFiles.packsDir}')..createSync(recursive: true);
    final seed = ContentDatabase(NativeDatabase(File('${packs.path}/${AppFiles.contentDb}')));
    await tester.runAsync(() async {
      await ContentSeed.insert(seed);
      await seed.close();
    });
    File('${root.path}/${AppFiles.settingsFile}').writeAsStringSync(jsonEncode({
      'onboarding_done': true,
      'installed_pack_version': 1,
      'grade': 9,
      'student_name': 'سلمى',
    }));

    await boot(tester, root);
    expect(find.text('العلوم والحياة'), findsOneWidget, reason: 'splash should go to the shell');

    await tester.tap(find.text('العلوم والحياة'));
    await settle(tester);
    expect(find.text('الكهرباء الساكنة'), findsOneWidget);
    expect(find.text('طرق الشحن الكهربائي'), findsOneWidget, reason: 'first unit starts expanded');

    await tester.tap(find.text('طرق الشحن الكهربائي'));
    await settle(tester);
    expect(find.text(AppStrings.askTutor), findsOneWidget);

    await tester.tap(find.text(AppStrings.askTutor));
    await settle(tester);
    // No model is downloaded, so the tutor tab offers setup instead of a chat.
    expect(find.text(AppStrings.tutorNeedsSetup), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
