import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/subjects/presentation/widgets/subject_strings.dart';

import 'subject_fixtures.dart';

void main() {
  final page = SubjectHarness();
  tearDown(Get.reset);

  for (final (mode, theme) in [('light', AppTheme.light), ('dark', AppTheme.dark)]) {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets('$mode at text scale $scale lays out without overflow', (tester) async {
        await page.pump(tester,
            theme: theme, textScale: scale, lastOpened: {'science': 'charging'});
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('الخلية'));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView), const Offset(0, -4000));
        await tester.pumpAndSettle();
        expect(find.text('الكشّاف الكهربائي'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('$mode at text scale $scale shows the empty state', (tester) async {
        await page.pump(tester, theme: theme, textScale: scale, units: const {});
        expect(find.text(SubjectStrings.emptyTitle), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('$mode at text scale $scale shows the failure state', (tester) async {
        await page.pump(tester,
            theme: theme, textScale: scale, failure: const DatabaseFailure('closed'));
        expect(find.text(SubjectStrings.failureTitle), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
