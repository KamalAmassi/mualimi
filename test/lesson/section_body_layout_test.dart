import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/lesson/domain/entities/callout_kind.dart';
import 'package:mualimi/features/lesson/presentation/widgets/viewer_strings.dart';

import 'viewer_fakes.dart';
import 'viewer_page_harness.dart';

final _word = String.fromCharCodes([0x0627, 0x0644, 0x0634, 0x062D, 0x0646, 0x0629]);
final _sentence = List.filled(30, _word).join(' ');
final _wideRow = List.filled(8, '| $_word $_word $_word ').join();
final _longFormula = List.filled(12, r'\frac{q_1 q_2}{r^2}').join(' + ');

final _mixedBody = [
  '## $_word',
  '$_sentence **$_word** \$F = k \frac{q_1 q_2}{r^2}\$ $_sentence',
  '### $_word',
  '- $_sentence\n- **$_word** \$x^2\$',
  '\$\$$_longFormula\$\$',
  '> **${CalloutKind.remember.marker}** $_sentence',
  '> **${CalloutKind.warning.marker}** $_sentence',
  '$_wideRow|\n${List.filled(8, '|---').join()}|\n$_wideRow|',
  '![$_word](images/missing.webp)',
  '$_sentence \$$_longFormula\$ $_sentence',
].join('\n\n');

void main() {
  setUpAll(loadAppFont);
  tearDown(Get.reset);

  for (final (name, theme) in [('light', AppTheme.light), ('dark', AppTheme.dark)]) {
    for (final deviceScale in [1.0, 1.3, 2.0]) {
      testWidgets('$name at device scale $deviceScale renders a long mixed body without overflow',
          (tester) async {
        await pumpViewer(
          tester,
          FakeViewerLessonRepository(lesson: viewerLesson(body: _mixedBody)),
          preferences: FakeReadingPreferences(1.3),
          theme: theme,
          deviceTextScale: deviceScale,
        );
        expect(tester.takeException(), isNull);
        expect(find.byType(Math), findsWidgets);

        final article = find.byWidgetPredicate(
            (w) => w is SingleChildScrollView && w.scrollDirection == Axis.vertical);
        await tester.drag(article.first, const Offset(0, -20000));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text(ViewerStrings.explainSection), findsOneWidget);

        final displayMath =
            find.byWidgetPredicate((w) => w is Math && w.mathStyle == MathStyle.display);
        for (final wide in [find.byType(Table), displayMath]) {
          final scrollable = find.ancestor(of: wide, matching: find.byType(Scrollable));
          final position = tester.state<ScrollableState>(scrollable.first).position;
          expect(position.axis, Axis.horizontal);
          expect(position.maxScrollExtent, greaterThan(0));
        }
      });
    }
  }
}
