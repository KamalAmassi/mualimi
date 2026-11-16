import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/app_colors.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/onboarding/presentation/pages/splash_page.dart';
import 'package:mualimi/features/onboarding/presentation/widgets/splash_strings.dart';

const _designSize = Size(390, 844);

/// Pulls the exact text of a `<div>` with the given style prefix out of the
/// design HTML, so the strings are checked against the source, not retyped.
String _htmlText(String html, String stylePrefix) {
  final match = RegExp('style="$stylePrefix[^"]*">([^<]*)<').firstMatch(html);
  return match!.group(1)!;
}

Future<void> _pumpSplash(WidgetTester tester, ThemeData theme, {double textScale = 1}) async {
  tester.view.physicalSize = _designSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    theme: theme,
    home: MediaQuery(
      data: MediaQueryData(size: _designSize, textScaler: TextScaler.linear(textScale)),
      child: const Directionality(textDirection: TextDirection.rtl, child: SplashPage()),
    ),
  ));
  await tester.pump();
}

void main() {
  final html = File('design/screens/light/Splash.html').readAsStringSync();

  test('tagline equals the agreed copy (intentionally not the design HTML)', () {
    // رزمتك التعليمية في جيبك · تعمل بدون إنترنت — separator is U+00B7.
    const agreed = 'رزمتك التعلي'
        'مية في جيبك · تعم'
        'ل بدون إنترنت';
    expect(SplashStrings.tagline, agreed);
    expect(SplashStrings.tagline, contains(' · '));
  });

  test('footer, app name and dot equal the design HTML text exactly', () {
    expect(SplashStrings.footer, _htmlText(html, 'font-size: 12px'));
    expect(_htmlText(html, 'font-size: 56px'), AppStrings.appName);
    expect(html, contains('<span style="color: #DCD6FF">${SplashStrings.nameDot}</span>'));
  });

  for (final (mode, theme, colors) in [
    ('light', AppTheme.light, AppColors.light),
    ('dark', AppTheme.dark, AppColors.dark),
  ]) {
    group('SplashPage ($mode)', () {
      testWidgets('shows the name, dot, tagline and footer', (tester) async {
        await _pumpSplash(tester, theme);
        expect(find.text('${AppStrings.appName}${SplashStrings.nameDot}', findRichText: true),
            findsOneWidget);
        final tagline = find.text(SplashStrings.tagline);
        expect(tagline, findsOneWidget);
        expect(tester.widget<Text>(tagline).data, SplashStrings.tagline);
        expect(find.text(SplashStrings.footer), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('uses the theme hero color as background', (tester) async {
        await _pumpSplash(tester, theme);
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, colors.hero);
      });

      testWidgets('progress fill is a static 55% starting at the reading edge', (tester) async {
        await _pumpSplash(tester, theme);
        final fill = tester.widget<FractionallySizedBox>(find.byType(FractionallySizedBox));
        expect(fill.widthFactor, 0.55);
        final align = tester.widget<Align>(
            find.ancestor(of: find.byType(FractionallySizedBox), matching: find.byType(Align)).first);
        expect(align.alignment, AlignmentDirectional.centerStart);
        // In RTL the fill hugs the right edge of the track.
        final track = tester.getRect(find.ancestor(
            of: find.byType(FractionallySizedBox), matching: find.byType(Container)).first);
        final fillRect = tester.getRect(find.descendant(
            of: find.byType(FractionallySizedBox), matching: find.byType(DecoratedBox)));
        expect(fillRect.right, closeTo(track.right, 0.01));
        expect(fillRect.width, closeTo(track.width * 0.55, 0.01));
      });

      testWidgets('does not overflow at a large text scale', (tester) async {
        await _pumpSplash(tester, theme, textScale: 1.6);
        expect(tester.takeException(), isNull);
        expect(find.text(SplashStrings.footer), findsOneWidget);
      });
    });
  }
}
