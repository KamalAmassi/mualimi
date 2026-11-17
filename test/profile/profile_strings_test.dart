import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/profile/presentation/widgets/profile_strings.dart';

/// Every text node of the design HTML, trimmed, in document order.
List<String> _htmlTexts(String path) => RegExp('>([^<]+)<')
    .allMatches(File(path).readAsStringSync())
    .map((m) => m.group(1)!.trim())
    .where((text) => text.isNotEmpty)
    .toList();

void main() {
  const lightPath = 'design/screens/light/Profile.html';
  final texts = _htmlTexts(lightPath);

  test('design strings equal the Profile design HTML text exactly', () {
    const fromDesign = [
      ProfileStrings.storageTitle,
      ProfileStrings.packSegment,
      ProfileStrings.pdfSegment,
      ProfileStrings.appearance,
      ProfileStrings.themeLight,
      ProfileStrings.themeDark,
      ProfileStrings.themeSystem,
      ProfileStrings.study,
      ProfileStrings.grade,
      ProfileStrings.change,
      ProfileStrings.fontSize,
      ProfileStrings.fontMedium,
      ProfileStrings.downloads,
      ProfileStrings.checkUpdate,
      ProfileStrings.aboutSection,
      ProfileStrings.about,
      ProfileStrings.aboutSubtitle,
    ];
    for (final value in fromDesign) {
      expect(texts, contains(value));
    }
  });

  test('composed lines match the design text', () {
    expect(texts, contains('الصف التاسع${ProfileStrings.separator}${ProfileStrings.noAccount}'));
    expect(texts, contains(ProfileStrings.packTitle('التاسع')));
    expect(
      texts,
      contains('${ProfileStrings.version(3).replaceFirst('3', '٣')}'
          '${ProfileStrings.separator}${ProfileStrings.upToDate}'),
    );
    expect(File(lightPath).readAsStringSync(),
        contains('aria-label="${ProfileStrings.editName}"'));
  });

  test('version uses Western digits', () {
    expect(ProfileStrings.version(3), 'الإصدار 3');
    expect(ProfileStrings.version(12), 'الإصدار 12');
  });

  test('dark design has the same texts as light', () {
    final dark = _htmlTexts('design/screens/dark/Profile.html');
    expect(dark.skip(2), texts.skip(2));
  });

  test('hand-typed font labels are the agreed copy, code point by code point', () {
    const large = [0x0643, 0x0628, 0x064A, 0x0631];
    expect(ProfileStrings.fontLarge.length, 4);
    expect(ProfileStrings.fontLarge.runes.toList(), large);
    expect(ProfileStrings.fontExtraLarge.length, 9);
    expect(ProfileStrings.fontExtraLarge.runes.toList(),
        [...large, 0x0020, 0x062C, 0x062F, 0x0627, 0x064B]);
    expect(texts, isNot(contains(ProfileStrings.fontLarge)));
    expect(texts, isNot(contains(ProfileStrings.fontExtraLarge)));
  });

  test('the on-device model and PDF delete items are not in the feature', () {
    final sources = Directory('lib/features/profile')
        .listSync(recursive: true)
        .whereType<File>()
        .map((f) => f.readAsStringSync())
        .join('\n');
    for (final dropped in ['Gemma', 'GB', '200 MB', 'حذف', 'جاهز', 'درساً', 'المعلّم الذكي']) {
      expect(sources, isNot(contains(dropped)), reason: dropped);
    }
  });
}
