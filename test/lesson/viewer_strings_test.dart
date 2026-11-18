import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/lesson/presentation/controllers/viewer_tab.dart';
import 'package:mualimi/features/lesson/presentation/widgets/viewer_strings.dart';

/// Every text node of the design HTML, trimmed, in document order.
List<String> _htmlTexts(String html) => RegExp('>([^<]+)<')
    .allMatches(html)
    .map((m) => m.group(1)!.trim())
    .where((text) => text.isNotEmpty)
    .toList();

/// The design writes digits as Arabic-Indic; the app uses Western digits.
String _arabicIndic(String text) => text.replaceAllMapped(
    RegExp('[0-9]'), (m) => String.fromCharCode(0x0660 + int.parse(m.group(0)!)));

void main() {
  final html = File('design/screens/light/Viewer.html').readAsStringSync();
  final texts = _htmlTexts(html);

  test('design strings equal the Viewer design HTML text exactly', () {
    const fromDesign = [
      ViewerStrings.explanationTab,
      ViewerStrings.pdfTab,
      ViewerStrings.solutionsTab,
      ViewerStrings.previous,
      ViewerStrings.explainSection,
      ViewerStrings.next,
    ];
    for (final value in fromDesign) {
      expect(texts, contains(value));
    }
    expect(html, contains('aria-label="${ViewerStrings.close}"'));
    expect(html, contains('aria-label="${ViewerStrings.fontSize}"'));
  });

  test('tab labels come from the design in design order', () {
    expect(ViewerTab.values.map((t) => t.label).toList(), [
      ViewerStrings.explanationTab,
      ViewerStrings.pdfTab,
      ViewerStrings.solutionsTab,
    ]);
  });

  test('the section counter rebuilds the design text with Western digits', () {
    expect(texts, contains(_arabicIndic(ViewerStrings.sectionCounter(2, 4))));
    expect(ViewerStrings.sectionCounter(2, 4),
        '${ViewerStrings.sectionWord} 2 ${ViewerStrings.ofWord} 4');
  });

  test('copy outside the design, code point by code point', () {
    const empty = [
      0x0644, 0x0627, 0x0020, 0x064A, 0x0648, 0x062C, 0x062F, 0x0020, //
      0x0634, 0x0631, 0x062D, 0x0020, 0x0644, 0x0647, 0x0630, 0x0627,
      0x0020, 0x0627, 0x0644, 0x062F, 0x0631, 0x0633,
    ];
    const loadFailed = [
      0x062A, 0x0639, 0x0630, 0x0651, 0x0631, 0x0020, 0x0641, 0x062A, //
      0x062D, 0x0020, 0x0627, 0x0644, 0x062F, 0x0631, 0x0633,
    ];
    expect(ViewerStrings.empty.runes.toList(), empty);
    expect(ViewerStrings.loadFailed.runes.toList(), loadFailed);
  });
}
