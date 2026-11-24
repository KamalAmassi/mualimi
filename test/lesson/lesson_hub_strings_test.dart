import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/lesson/presentation/widgets/lesson_hub_strings.dart';

/// Every text node of the design HTML, trimmed, in document order.
List<String> _htmlTexts(String html) => RegExp('>([^<]+)<')
    .allMatches(html)
    .map((m) => m.group(1)!.trim())
    .where((text) => text.isNotEmpty)
    .toList();

/// The design writes counts with Arabic-Indic digits; the app uses Western digits.
String _arabicIndic(String text) => text.replaceAllMapped(
    RegExp('[0-9]'), (m) => String.fromCharCode(0x0660 + int.parse(m.group(0)!)));

void main() {
  final lessonHtml = File('design/screens/light/Lesson.html').readAsStringSync();
  final mathHtml = File('design/screens/light/LessonMath.html').readAsStringSync();
  final lessonTexts = _htmlTexts(lessonHtml);
  final mathTexts = _htmlTexts(mathHtml);

  test('design strings equal the Lesson design HTML text exactly', () {
    for (final value in [
      LessonHubStrings.filesTitle,
      LessonHubStrings.pdfTitle,
      LessonHubStrings.explanationTitle,
      LessonHubStrings.keyTermsTitle,
      LessonHubStrings.askTutorTitle,
    ]) {
      expect(lessonTexts, contains(value));
    }
    expect(lessonHtml, contains('aria-label="${LessonHubStrings.back}"'));
  });

  test('the tutor-unavailable card copies LessonMath.html', () {
    expect(mathTexts, contains(LessonHubStrings.tutorUnavailableBody));
    expect(mathTexts, contains(LessonHubStrings.comingSoon));
    expect(
      mathTexts.where((t) => t.startsWith('${LessonHubStrings.tutorUnavailableTitle} ')),
      hasLength(1),
    );
  });

  test('the ask-tutor subtitle is the design text without its offline claim', () {
    final design = lessonTexts.firstWhere((t) => t.startsWith(LessonHubStrings.askTutorSubtitle));
    expect(design.split(LessonHubStrings.separator).first, LessonHubStrings.askTutorSubtitle);
    expect(design, isNot(LessonHubStrings.askTutorSubtitle));
  });

  test('counts and pages rebuild the design lines', () {
    final pdfLine = LessonHubStrings.join(
        [LessonHubStrings.pdfLabel, '820 KB', LessonHubStrings.pages(44, 49)]);
    expect(lessonTexts, contains(pdfLine));
    final explanationLine = LessonHubStrings.join(
        [LessonHubStrings.sectionsCount(4), LessonHubStrings.readyInApp]);
    expect(lessonTexts, contains(_arabicIndic(explanationLine)));
    expect(lessonTexts, contains(_arabicIndic(LessonHubStrings.cardsCount(5))));
  });

  test('pages use Western digits and collapse a single page', () {
    expect(LessonHubStrings.pages(44, 49), 'ص 44–49');
    expect(LessonHubStrings.pages(44, 44), 'ص 44');
    expect(LessonHubStrings.pages(44, null), 'ص 44');
    expect(LessonHubStrings.pages(null, null), isNull);
  });

  test('join skips missing and empty parts', () {
    expect(LessonHubStrings.join(['a', null, '', 'b']), 'a${LessonHubStrings.separator}b');
  });

  test('the empty-lesson title is the agreed copy, code point for code point', () {
    // محتوى هذا الدرس غير متوفر بعد
    expect(LessonHubStrings.emptyTitle.runes.toList(), const [
      0x0645, 0x062D, 0x062A, 0x0648, 0x0649, 0x0020,
      0x0647, 0x0630, 0x0627, 0x0020,
      0x0627, 0x0644, 0x062F, 0x0631, 0x0633, 0x0020,
      0x063A, 0x064A, 0x0631, 0x0020,
      0x0645, 0x062A, 0x0648, 0x0641, 0x0631, 0x0020,
      0x0628, 0x0639, 0x062F,
    ]);
  });
}
