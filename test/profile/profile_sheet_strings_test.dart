import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/features/content_manager/presentation/constants/grade_ordinals.dart';
import 'package:mualimi/features/profile/presentation/widgets/profile_sheet_strings.dart';
import 'package:mualimi/features/profile/presentation/widgets/profile_strings.dart';

/// Every text node of the design HTML, trimmed, in document order.
List<String> _htmlTexts(String path) => RegExp('>([^<]+)<')
    .allMatches(File(path).readAsStringSync())
    .map((m) => m.group(1)!.trim())
    .where((text) => text.isNotEmpty)
    .toList();

void main() {
  const editName = 'design/screens/light/EditName.html';
  const changeGrade = 'design/screens/light/ChangeGrade.html';
  final nameTexts = _htmlTexts(editName);
  final gradeTexts = _htmlTexts(changeGrade);
  final designNote = gradeTexts.firstWhere((t) => t.startsWith('تُنزَّل'));

  test('edit name copy equals the design text', () {
    for (final value in [
      ProfileStrings.editName,
      ProfileSheetStrings.yourName,
      ProfileSheetStrings.nameNote,
      AppStrings.save,
    ]) {
      expect(nameTexts, contains(value), reason: value);
    }
  });

  test('change grade copy equals the design text', () {
    for (final value in [
      AppStrings.changeGrade,
      ProfileSheetStrings.currentGrade,
      ProfileSheetStrings.gradeNoteTitle,
      ProfileSheetStrings.chooseGradeToContinue,
      AppStrings.comingSoon,
      for (var grade = 7; grade <= 12; grade++) GradeOrdinals.of(grade),
    ]) {
      expect(gradeTexts, contains(value), reason: value);
    }
  });

  test('both sheets label the close button like the design', () {
    for (final path in [editName, changeGrade]) {
      expect(File(path).readAsStringSync(), contains('aria-label="${AppStrings.close}"'));
    }
  });

  test('dark designs have the same texts as light', () {
    expect(_htmlTexts('design/screens/dark/EditName.html').skip(2), nameTexts.skip(2));
    expect(_htmlTexts('design/screens/dark/ChangeGrade.html').skip(2), gradeTexts.skip(2));
  });

  test('the note body keeps the design wording minus the tutor clause', () {
    const body = ProfileSheetStrings.gradeNoteBody;
    final head = designNote.substring(0, designNote.indexOf('، ') + 2);
    final tail = designNote.substring(designNote.indexOf('محفوظاتك'));
    expect(body, '$head${String.fromCharCodes(const [0x0648, 0x062A, 0x0628, 0x0642, 0x0649])} $tail');
    expect(body.runes.length, 60);
    expect(body, isNot(contains('المعلّم')));
    expect(gradeTexts, isNot(contains(body)));
  });
}
