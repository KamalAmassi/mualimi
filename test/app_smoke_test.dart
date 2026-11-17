import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mualimi/app.dart';
import 'package:mualimi/core/bindings/initial_binding.dart';
import 'package:mualimi/core/constants/app_files.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/services/device_info_source.dart';
import 'package:mualimi/core/services/device_snapshot.dart';
import 'package:mualimi/features/content_manager/presentation/constants/grade_ordinals.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/routes/tutor_args.dart';
import 'package:mualimi/features/onboarding/presentation/controllers/splash_timing.dart';
import 'package:mualimi/features/onboarding/presentation/widgets/grade_strings.dart';

class _WifiConnectivity extends Fake implements Connectivity {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async =>
      [ConnectivityResult.wifi];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      const Stream.empty();
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
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 40)));
    await tester.pump(const Duration(milliseconds: 40));
  }
}

Future<void> boot(WidgetTester tester, Directory root) async {
  final binding = await tester.runAsync(() => InitialBinding.create(
        rootOverride: root,
        connectivityPlugin: _WifiConnectivity(),
        deviceInfo: _RoomyDevice(),
      ));
  await tester.pumpWidget(MualimiApp(initialBinding: binding!));
  await tester.pump(SplashTiming.minDisplay);
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

  testWidgets('first run walks splash -> welcome -> grade -> download',
      (tester) async {
    await boot(tester, root);
    expect(find.byType(TextField), findsOneWidget,
        reason: 'splash should go to welcome');

    await tester.enterText(find.byType(TextField), 'سلمى');
    await tester.tap(find.text(AppStrings.next));
    await settle(tester, rounds: 12); // let the route animation finish
    expect(find.text(GradeOrdinals.of(9)), findsOneWidget);

    await tester.tap(find.text(GradeOrdinals.of(9)));
    await tester.pump();
    await tester.tap(find.text(GradeStrings.downloadLabel(9)));
    await settle(tester);

    // The test HTTP client refuses every request, so the manifest can't load:
    // the download screen must land on its failed state, not crash.
    expect(find.text(AppStrings.downloadFailed), findsOneWidget);
    expect(find.text(AppStrings.retry), findsOneWidget);
  });

  testWidgets('an empty name is rejected on the welcome screen',
      (tester) async {
    await boot(tester, root);
    await tester.tap(find.text(AppStrings.next));
    await settle(tester, rounds: 3);
    expect(find.text(AppStrings.studentNameInvalid), findsOneWidget);
  });

  Future<void> bootReturningStudent(WidgetTester tester) async {
    final packs = Directory('${root.path}/${AppFiles.packsDir}')
      ..createSync(recursive: true);
    final seed = ContentDatabase(
        NativeDatabase(File('${packs.path}/${AppFiles.contentDb}')));
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
    await boot(tester, root);
  }

  Future<void> openTutorFromLesson(WidgetTester tester) async {
    await tester.tap(find.text('العلوم والحياة'));
    await settle(tester);
    await tester.tap(find.text('طرق الشحن الكهربائي'));
    await settle(tester);
    await tester.tap(find.text(AppStrings.askTutor));
    await settle(tester);
  }

  testWidgets(
      'returning student: splash -> shell -> subject -> lesson -> tutor',
      (tester) async {
    await bootReturningStudent(tester);
    expect(find.text('العلوم والحياة'), findsOneWidget,
        reason: 'splash should go to the shell');

    await tester.tap(find.text('العلوم والحياة'));
    await settle(tester);
    expect(find.text('الكهرباء الساكنة'), findsOneWidget);
    expect(find.text('طرق الشحن الكهربائي'), findsOneWidget,
        reason: 'first unit starts expanded');

    await tester.tap(find.text('طرق الشحن الكهربائي'));
    await settle(tester);
    expect(find.text(AppStrings.askTutor), findsOneWidget);

    await tester.tap(find.text(AppStrings.askTutor));
    await settle(tester);
    // The lesson is pre-selected and the chat is ready to take a question.
    expect(find.text(AppStrings.askHint), findsOneWidget);
    expect(find.text(AppStrings.lessonLabel), findsOneWidget);
    expect(find.byIcon(LucideIcons.arrowRight), findsOneWidget,
        reason: 'the tutor opens full screen with a back button');
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets(
      'a question from the pack bank is answered offline with its source',
      (tester) async {
    await bootReturningStudent(tester);
    await openTutorFromLesson(tester);

    await tester.enterText(
        find.byType(TextField), 'ما هي طرق الشحن الكهربائي؟');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);

    expect(find.text(AppStrings.fromPack), findsOneWidget);
    expect(
        find.textContaining('الشحن بالدلك، والشحن بالتماس', findRichText: true),
        findsOneWidget);
    expect(
        find.textContaining('${AppStrings.sourceLabel}:', findRichText: true),
        findsOneWidget);
    expect(find.text(AppStrings.save), findsOneWidget);
  });

  testWidgets(
      'an in-scope question without the cloud tutor is queued with its passages',
      (tester) async {
    await bootReturningStudent(tester);
    await openTutorFromLesson(tester);

    await tester.enterText(find.byType(TextField), 'لماذا ينفرج ورقتا الكشاف؟');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);

    expect(find.text(AppStrings.pendingBadge), findsOneWidget);
    expect(find.text(AppStrings.nearestPassages), findsOneWidget);
    expect(find.text(AppStrings.openInPack), findsWidgets);
  });

  testWidgets('a question outside the pack gets the out-of-scope message',
      (tester) async {
    await bootReturningStudent(tester);
    await openTutorFromLesson(tester);

    await tester.enterText(find.byType(TextField), 'من اخترع البطارية؟');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);

    expect(find.text(AppStrings.outOfScopeTitle), findsOneWidget);
  });

  testWidgets('the tutor route opens full screen with the subject and lesson pre-selected', (tester) async {
    await bootReturningStudent(tester);

    Get.toNamed<void>(
      AppRoutes.tutor,
      arguments: const TutorArgs(
          subjectId: DevSeedScienceG9.subjectId, lessonId: DevSeedScienceG9.lessonId),
    );
    await settle(tester);

    expect(find.text(AppStrings.askHint), findsOneWidget);
    expect(find.text(DevSeedScienceG9.lessonTitle), findsWidgets);
    expect(find.byIcon(LucideIcons.arrowRight), findsOneWidget, reason: 'back button');

    await tester.tap(find.byIcon(LucideIcons.arrowRight));
    await settle(tester);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byIcon(LucideIcons.arrowRight), findsNothing);
  });

  testWidgets('the tutor route with invalid arguments still opens', (tester) async {
    await bootReturningStudent(tester);

    Get.toNamed<void>(AppRoutes.tutor, arguments: 'not tutor args');
    await settle(tester);

    expect(find.text(AppStrings.askHint), findsOneWidget);
    expect(find.byIcon(LucideIcons.arrowRight), findsOneWidget);
  });
}
