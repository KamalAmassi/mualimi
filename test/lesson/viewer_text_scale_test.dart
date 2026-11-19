import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/constants/app_colors.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/lesson/presentation/widgets/viewer_dimens.dart';
import 'package:mualimi/features/lesson/presentation/widgets/viewer_strings.dart';

import 'viewer_fakes.dart';
import 'viewer_page_harness.dart';

RenderParagraph _paragraph(WidgetTester tester, String text) =>
    tester.renderObject<RenderParagraph>(find.text(text));

double _fontSize(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style!.fontSize!;

/// The device scale every chrome label is rendered with, whatever the reading factor.
void _expectChromeAt(WidgetTester tester, double deviceScale) {
  final chrome = TextScaler.linear(deviceScale.clamp(1.0, ViewerDimens.chromeMaxTextScale));
  for (final label in ['Charging', ViewerStrings.explanationTab, ViewerStrings.next]) {
    expect(_paragraph(tester, label).textScaler, chrome, reason: label);
  }
}

/// Body and heading keep the device scaler and carry the reading factor in their size.
void _expectArticleAt(WidgetTester tester, String section, String body,
    {required double deviceScale, required double factor}) {
  final device = TextScaler.linear(deviceScale);
  expect(_paragraph(tester, section).textScaler, device);
  expect(_paragraph(tester, body).textScaler, device);
  expect(_fontSize(tester, section), closeTo(ViewerDimens.headingSize * factor, 0.001));
  expect(_fontSize(tester, body), closeTo(ViewerDimens.bodySize * factor, 0.001));
}

void main() {
  setUpAll(loadAppFont);
  tearDown(Get.reset);

  testWidgets('the Aa button cycles the explanation size, saves it and leaves the chrome',
      (tester) async {
    final prefs = FakeReadingPreferences();
    await pumpViewer(tester, FakeViewerLessonRepository(), preferences: prefs, deviceTextScale: 1.3);
    _expectArticleAt(tester, 'Section 1', 'Body 1', deviceScale: 1.3, factor: 1.0);
    final before = tester.getSize(find.text('Body 1')).height;

    for (final factor in [1.15, 1.3, 1.0]) {
      await tester.tap(find.byTooltip(ViewerStrings.fontSize));
      await tester.pumpAndSettle();
      expect(prefs.fontScale, factor);
      _expectArticleAt(tester, 'Section 1', 'Body 1', deviceScale: 1.3, factor: factor);
      _expectChromeAt(tester, 1.3);
      if (factor == 1.15) expect(tester.getSize(find.text('Body 1')).height, greaterThan(before));
    }
  });

  testWidgets('the saved factor is applied when the viewer opens', (tester) async {
    await pumpViewer(tester, FakeViewerLessonRepository(), preferences: FakeReadingPreferences(1.3));
    _expectArticleAt(tester, 'Section 1', 'Body 1', deviceScale: 1.0, factor: 1.3);
    _expectChromeAt(tester, 1.0);
  });

  final longBody = List.filled(80, 'نص طويل للشرح').join(' ');
  for (final (name, theme, colors) in [
    ('light', AppTheme.light, AppColors.light),
    ('dark', AppTheme.dark, AppColors.dark),
  ]) {
    for (final deviceScale in [1.0, 1.3, 2.0]) {
      for (final factor in [1.0, 1.3]) {
        testWidgets('$name at device scale $deviceScale and factor $factor lays out without overflow',
            (tester) async {
          await pumpViewer(
            tester,
            FakeViewerLessonRepository(lesson: viewerLesson(body: longBody), lastSection: 1),
            preferences: FakeReadingPreferences(factor),
            theme: theme,
            deviceTextScale: deviceScale,
          );
          expect(tester.takeException(), isNull);
          _expectArticleAt(tester, 'Section 2', '$longBody 2',
              deviceScale: deviceScale, factor: factor);
          _expectChromeAt(tester, deviceScale);
          expect(tester.widget<Text>(find.text('Section 2')).style?.color, colors.primary);
          await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -4000));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.text(ViewerStrings.explainSection), findsOneWidget);
        });
      }
    }
  }
}
