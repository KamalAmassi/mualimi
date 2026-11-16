import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/onboarding/presentation/widgets/welcome_strings.dart';

/// Every text node of the design HTML, trimmed, in document order.
List<String> _htmlTexts(String html) => RegExp('>([^<]+)<')
    .allMatches(html)
    .map((m) => m.group(1)!.trim())
    .where((text) => text.isNotEmpty)
    .toList();

void main() {
  final texts = _htmlTexts(File('design/screens/light/Welcome.html').readAsStringSync());

  test('design strings equal the Welcome design HTML text exactly', () {
    const fromDesign = [
      WelcomeStrings.offlineChip,
      WelcomeStrings.title,
      WelcomeStrings.subtitle,
      WelcomeStrings.intro,
      WelcomeStrings.lessonsTitle,
      WelcomeStrings.lessonsDescription,
      WelcomeStrings.sourceTitle,
      WelcomeStrings.sourceDescription,
      WelcomeStrings.nameLabel,
      WelcomeStrings.privacyNote,
      WelcomeStrings.step,
    ];
    for (final value in fromDesign) {
      expect(texts, contains(value));
    }
  });

  test('the design tutor row is replaced, not kept', () {
    final tutorIndex = texts.indexOf(WelcomeStrings.lessonsDescription) + 1;
    final designTitle = texts[tutorIndex];
    final designDescription = texts[tutorIndex + 1];
    expect(texts[tutorIndex + 2], WelcomeStrings.sourceTitle);
    expect(WelcomeStrings.tutorTitle, isNot(designTitle));
    expect(WelcomeStrings.tutorDescription, isNot(designDescription));
  });

  test('tutor title is the v2 copy, code point by code point', () {
    const expected = [
      0x0645, 0x0639, 0x0644, 0x0651, 0x0645, 0x0020, 0x0630, 0x0643, //
      0x064A, 0x0020, 0x064A, 0x062C, 0x0627, 0x0648, 0x0628, 0x0020,
      0x0645, 0x0646, 0x0020, 0x0631, 0x0632, 0x0645, 0x062A, 0x0643,
    ];
    expect(WelcomeStrings.tutorTitle.length, 24);
    expect(WelcomeStrings.tutorTitle.runes.toList(), expected);
  });

  test('tutor description is the v2 copy, code point by code point', () {
    const expected = [
      0x0623, 0x062C, 0x0648, 0x0628, 0x0629, 0x0020, 0x062C, 0x0627, //
      0x0647, 0x0632, 0x0629, 0x0020, 0x0628, 0x062F, 0x0648, 0x0646,
      0x0020, 0x0646, 0x062A, 0x060C, 0x0020, 0x0648, 0x0623, 0x064A,
      0x0020, 0x0633, 0x0624, 0x0627, 0x0644, 0x0020, 0x0644, 0x0645,
      0x0627, 0x0020, 0x064A, 0x062A, 0x0648, 0x0641, 0x0631, 0x0020,
      0x0627, 0x0644, 0x0646, 0x062A,
    ];
    expect(WelcomeStrings.tutorDescription.length, 44);
    expect(WelcomeStrings.tutorDescription.runes.toList(), expected);
  });
}
