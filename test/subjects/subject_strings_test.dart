import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/subjects/presentation/widgets/subject_strings.dart';

/// Every text node of the design HTML, trimmed, in document order.
List<String> _htmlTexts(String source) => RegExp('>([^<]+)<')
    .allMatches(source)
    .map((m) => m.group(1)!.trim())
    .where((text) => text.isNotEmpty)
    .toList();

List<String> _ariaLabels(String source) =>
    RegExp('aria-label="([^"]+)"').allMatches(source).map((m) => m.group(1)!).toList();

String _arabicDigits(String text) =>
    text.replaceAllMapped(RegExp('[0-9]'), (m) => String.fromCharCode(0x0660 + int.parse(m[0]!)));

void main() {
  final light = File('design/screens/light/Subject.html').readAsStringSync();
  final texts = _htmlTexts(light);
  final labels = _ariaLabels(light);

  test('header button labels equal the design aria-labels', () {
    expect(labels, contains(SubjectStrings.back));
    expect(labels, contains(SubjectStrings.askTutorAboutSubject));
  });

  test('lesson counts match the design with Western digits', () {
    expect(texts, contains(_arabicDigits(SubjectStrings.lessonsCount(3))));
    expect(SubjectStrings.lessonsCount(3), '3 دروس');
  });

  test('header subtitle pieces match the design', () {
    final header = texts.firstWhere((t) => t.endsWith(SubjectStrings.unitsNoun));
    final parts = header.split(SubjectStrings.separator);
    expect(parts.first, 'الصف التاسع');
    expect(parts.last, _arabicDigits(SubjectStrings.unitsCount(4)));
    expect(SubjectStrings.unitsCount(4), '4 وحدات');
  });

  test('book pages and the last lesson marker match the design', () {
    expect(texts, contains(SubjectStrings.bookPages(40, 43)));
    expect(texts,
        contains(SubjectStrings.lessonSubtitle(from: 44, to: 49, lastOpened: true)));
    expect(texts, contains(SubjectStrings.lessonSubtitle(from: 50, to: 53, lastOpened: false)));
  });

  test('book pages without a range or without pages', () {
    expect(SubjectStrings.bookPages(40, 40), 'صفحات الكتاب 40');
    expect(SubjectStrings.bookPages(40, null), 'صفحات الكتاب 40');
    expect(SubjectStrings.bookPages(null, 43), isNull);
    expect(SubjectStrings.lessonSubtitle(lastOpened: true), SubjectStrings.lastOpened);
    expect(SubjectStrings.lessonSubtitle(lastOpened: false), isNull);
  });

  test('dark design has the same texts and labels as light', () {
    final dark = File('design/screens/dark/Subject.html').readAsStringSync();
    expect(_htmlTexts(dark).skip(2), texts.skip(2));
    expect(_ariaLabels(dark), labels);
  });

  test('empty title is the agreed copy, code point by code point', () {
    const expected = [
      0x0644, 0x0627, 0x0020, 0x062A, 0x0648, 0x062C, 0x062F, 0x0020, 0x062F, 0x0631, //
      0x0648, 0x0633, 0x0020, 0x0641, 0x064A, 0x0020, 0x0647, 0x0630, 0x0647, 0x0020,
      0x0627, 0x0644, 0x0645, 0x0627, 0x062F, 0x0629, 0x0020, 0x0628, 0x0639, 0x062F,
    ];
    expect(SubjectStrings.emptyTitle.length, 30);
    expect(SubjectStrings.emptyTitle.runes.toList(), expected);
  });

  test('failure title is the agreed copy, code point by code point', () {
    const expected = [
      0x062A, 0x0639, 0x0630, 0x0651, 0x0631, 0x0020, 0x0641, 0x062A, 0x062D, 0x0020, //
      0x062F, 0x0631, 0x0648, 0x0633, 0x0020, 0x0627, 0x0644, 0x0645, 0x0627, 0x062F,
      0x0629,
    ];
    expect(SubjectStrings.failureTitle.length, 21);
    expect(SubjectStrings.failureTitle.runes.toList(), expected);
  });
}
