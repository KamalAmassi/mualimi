import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/theme/app_theme.dart';

import 'profile_sheet_harness.dart';

void main() {
  tearDown(Get.reset);

  final openers = {
    'edit name': openEditName,
    'change grade': openChangeGrade,
    'about': openAbout,
  };
  for (final (mode, theme) in [('light', AppTheme.light), ('dark', AppTheme.dark)]) {
    for (final scale in [1.0, 1.3, 2.0]) {
      for (final MapEntry(key: name, value: open) in openers.entries) {
        testWidgets('$name sheet, $mode at text scale $scale, has no overflow', (tester) async {
          await pumpProfile(tester, theme: theme, textScale: scale);
          await open(tester);
          expect(find.byType(BottomSheet), findsOneWidget);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
