import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/theme/app_theme.dart';

/// Pumps [child] in an RTL MaterialApp at 390×844 with [theme] and
/// [textScale]. When [framed] is false the child is placed at the top of a
/// plain page instead of being the page itself.
Future<void> pumpDownloadWidget(
  WidgetTester tester,
  Widget child, {
  ThemeData? theme,
  double textScale = 1.0,
  bool framed = false,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: theme ?? AppTheme.light,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MediaQuery(
          data: MediaQueryData(size: const Size(390, 844), textScaler: TextScaler.linear(textScale)),
          child: framed
              ? child
              : Scaffold(
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: child,
                  ),
                ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Every theme × text scale combination the widgets must survive.
final List<(String, ThemeData, double)> downloadRenderMatrix = [
  for (final t in [('light', AppTheme.light), ('dark', AppTheme.dark)])
    for (final s in [1.0, 1.3, 2.0]) (t.$1, t.$2, s),
];
