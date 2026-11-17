import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/features/lesson/presentation/widgets/key_terms_strings.dart';

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
  final html = File('design/screens/light/KeyTerms.html').readAsStringSync();
  final texts = _htmlTexts(html);

  test('design strings equal the KeyTerms design HTML text exactly', () {
    const fromDesign = [
      KeyTermsStrings.title,
      KeyTermsStrings.flipHint,
      KeyTermsStrings.previous,
      KeyTermsStrings.next,
      KeyTermsStrings.allTerms,
    ];
    for (final value in fromDesign) {
      expect(texts, contains(value));
    }
    expect(html, contains('aria-label="${KeyTermsStrings.back}"'));
  });

  test('counter and subtitle rebuild the design text around the numbers', () {
    expect(texts, contains(_arabicIndic(KeyTermsStrings.counter(4, 5))));
    expect(texts, contains(_arabicIndic(KeyTermsStrings.subtitle(DevSeedScienceG9.lessonTitle, 5))));
  });

  test('counter and subtitle use Western digits', () {
    expect(KeyTermsStrings.counter(4, 5),
        '${KeyTermsStrings.cardWord} 4 ${KeyTermsStrings.ofWord} 5');
    expect(KeyTermsStrings.subtitle(null, 12), '12 ${KeyTermsStrings.cardsNoun}');
  });

  test('empty state copy, code point by code point', () {
    const expected = [
      0x0644, 0x0627, 0x0020, 0x062A, 0x0648, 0x062C, 0x062F, 0x0020, //
      0x0645, 0x0635, 0x0637, 0x0644, 0x062D, 0x0627, 0x062A, 0x0020,
      0x0644, 0x0647, 0x0630, 0x0627, 0x0020, 0x0627, 0x0644, 0x062F,
      0x0631, 0x0633,
    ];
    expect(KeyTermsStrings.empty.runes.toList(), expected);
  });
}
