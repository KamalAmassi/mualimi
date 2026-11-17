import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/subjects/presentation/widgets/home_strings.dart';

/// Every text node of the design HTML, trimmed, in document order.
List<String> _htmlTexts(String path) => RegExp('>([^<]+)<')
    .allMatches(File(path).readAsStringSync())
    .map((m) => m.group(1)!.trim())
    .where((text) => text.isNotEmpty)
    .toList();

void main() {
  final texts = _htmlTexts('design/screens/light/Home.html');

  test('design strings equal the Home design HTML text exactly', () {
    const fromDesign = [
      HomeStrings.eveningGreeting,
      HomeStrings.offlineReady,
      HomeStrings.continueLabel,
      HomeStrings.yourSubjects,
      HomeStrings.availableOffline,
      HomeStrings.tutorSoon,
      HomeStrings.arabicGlyph,
      HomeStrings.englishGlyph,
      HomeStrings.mathGlyph,
    ];
    for (final value in fromDesign) {
      expect(texts, contains(value));
    }
  });

  test('count and subtitle formats match the design text', () {
    expect(texts, contains(HomeStrings.subjectsCount(8).replaceFirst('8', '٨')));
    expect(texts, contains('العلوم والحياة${HomeStrings.subtitleSeparator}الوحدة الثانية'));
    expect(HomeStrings.subjectsCount(8), '8 مواد');
  });

  test('dark design has the same texts as light', () {
    final dark = _htmlTexts('design/screens/dark/Home.html');
    expect(dark.skip(2), texts.skip(2));
  });

  test('the design tutor chip is replaced by the connectivity chips', () {
    final designChip = texts[texts.indexOf(HomeStrings.offlineReady) + 1];
    expect(designChip, isNot(HomeStrings.tutorOnline));
    expect(designChip, isNot(HomeStrings.tutorOffline));
    expect(texts, isNot(contains(HomeStrings.tutorOnline)));
    expect(texts, isNot(contains(HomeStrings.tutorOffline)));
  });

  test('online tutor chip is the agreed copy, code point by code point', () {
    const expected = [
      0x0627, 0x0644, 0x0645, 0x0639, 0x0644, 0x0651, 0x0645, 0x0020, //
      0x0627, 0x0644, 0x0630, 0x0643, 0x064A, 0x0020, 0x0645, 0x062A,
      0x0627, 0x062D,
    ];
    expect(HomeStrings.tutorOnline.length, 18);
    expect(HomeStrings.tutorOnline.runes.toList(), expected);
  });

  test('offline tutor chip is the agreed copy, code point by code point', () {
    const expected = [
      0x0623, 0x062C, 0x0648, 0x0628, 0x0629, 0x0020, 0x062C, 0x0627, //
      0x0647, 0x0632, 0x0629, 0x0020, 0x0628, 0x062F, 0x0648, 0x0646,
      0x0020, 0x0646, 0x062A,
    ];
    expect(HomeStrings.tutorOffline.length, 19);
    expect(HomeStrings.tutorOffline.runes.toList(), expected);
  });

  test('morning greeting is the agreed copy, code point by code point', () {
    const expected = [
      0x0635, 0x0628, 0x0627, 0x062D, 0x0020, 0x0627, 0x0644, 0x062E, 0x064A, 0x0631, //
    ];
    expect(HomeStrings.morningGreeting.length, 10);
    expect(HomeStrings.morningGreeting.runes.toList(), expected);
  });
}
