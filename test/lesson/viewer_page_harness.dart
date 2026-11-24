import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/lesson/domain/repositories/reading_preferences_repository.dart';
import 'package:mualimi/features/lesson/presentation/controllers/viewer_controller.dart';
import 'package:mualimi/features/lesson/presentation/pages/viewer_page.dart';

import 'section_body_fakes.dart';
import 'viewer_fakes.dart';

const _designSize = Size(390, 844);

/// The arguments the tutor route received in the last pumped viewer, if any.
Object? tutorArguments;

/// Opens the viewer for [viewerLessonId] at the phone design size, with
/// [deviceTextScale] standing in for the device's own text scale.
Future<ViewerController> pumpViewer(
  WidgetTester tester,
  FakeViewerLessonRepository lessons, {
  ReadingPreferencesRepository? preferences,
  bool subjectTutorEnabled = true,
  ThemeData? theme,
  double deviceTextScale = 1,
}) async {
  Get.put(sectionBodyController());
  final controller = Get.put(viewerController(
    lessons,
    preferences: preferences,
    subjectTutorEnabled: subjectTutorEnabled,
  ));
  tester.view.physicalSize = _designSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  tutorArguments = null;
  await tester.pumpWidget(GetMaterialApp(
    theme: theme ?? AppTheme.light,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(deviceTextScale)),
      child: Directionality(textDirection: TextDirection.rtl, child: child!),
    ),
    initialRoute: AppRoutes.viewerOf(viewerLessonId),
    getPages: [
      GetPage(name: AppRoutes.viewer, page: () => const ViewerPage()),
      GetPage(
        name: AppRoutes.tutor,
        page: () {
          tutorArguments = Get.arguments;
          return const Scaffold();
        },
      ),
    ],
  ));
  await tester.pumpAndSettle();
  return controller;
}

/// Loads the bundled app font so widths match the device, not the test font.
Future<void> loadAppFont() async {
  final loader = FontLoader('IBMPlexSansArabic');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    final bytes = File('assets/fonts/IBMPlexSansArabic-$weight.ttf').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}
