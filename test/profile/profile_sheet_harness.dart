import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/profile/domain/entities/profile.dart';
import 'package:mualimi/features/profile/presentation/pages/profile_page.dart';
import 'package:mualimi/features/profile/presentation/widgets/profile_strings.dart';

import 'profile_fakes.dart';

/// Profile at the design size, with a stub download route.
Future<ProfileFixture> pumpProfile(
  WidgetTester tester, {
  Profile profile = profileAhmad,
  ThemeData? theme,
  double textScale = 1,
}) async {
  final fixture = ProfileFixture(profile: profile);
  Get.put(fixture.controller());
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(GetMaterialApp(
    theme: theme ?? AppTheme.light,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
      child: Directionality(textDirection: TextDirection.rtl, child: child!),
    ),
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => const ProfilePage()),
      GetPage(name: AppRoutes.download, page: () => const Text('download')),
    ],
  ));
  await tester.pumpAndSettle();
  return fixture;
}

Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _tapOnPage(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tapAndSettle(tester, finder);
}

Future<void> openEditName(WidgetTester tester) =>
    tapAndSettle(tester, find.byIcon(LucideIcons.pencil));

Future<void> openChangeGrade(WidgetTester tester) =>
    _tapOnPage(tester, find.text(ProfileStrings.change));

Future<void> openAbout(WidgetTester tester) => _tapOnPage(tester, find.text(ProfileStrings.about));

Finder inSheet<T>(Finder finder) => find.descendant(of: find.byType(T), matching: finder);
