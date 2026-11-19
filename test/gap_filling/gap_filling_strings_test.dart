import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/limits.dart';
import 'package:mualimi/features/gap_filling/presentation/widgets/gap_filling_strings.dart';

import 'gap_filling_harness.dart';

const _forbidden = ['رسبت', 'ضعيف', 'فاشل', 'علامتك'];

void main() {
  test('no gap filling source file uses a forbidden word', () {
    final files = Directory('lib/features/gap_filling')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));
    expect(files, isNotEmpty);
    for (final file in files) {
      final text = file.readAsStringSync();
      for (final word in _forbidden) {
        expect(text.contains(word), isFalse, reason: '$word in ${file.path}');
      }
    }
  });

  test('no seeded skill, mini lesson or question uses a forbidden word', () async {
    final h = GapFillingHarness();
    await h.open();
    addTearDown(h.close);
    final skills = await h.content.select(h.content.skills).get();
    final questions = await h.content.select(h.content.diagnosticQuestions).get();
    final all = [
      for (final s in skills) ...[s.title, s.summary, s.miniLesson],
      for (final q in questions) ...[q.prompt, q.choicesJson, q.explanation],
    ].join('\n');
    for (final word in _forbidden) {
      expect(all.contains(word), isFalse, reason: word);
    }
  });

  test('the strings that mention scores never show a number or a percent', () {
    expect(GapFillingStrings.introBody.contains('%'), isFalse);
    expect(GapFillingStrings.reviewTryLater.contains(RegExp(r'[0-9٠-٩]')), isFalse);
    expect(GapFillingStrings.reviewStronger.contains(RegExp(r'[0-9٠-٩]')), isFalse);
  });

  test('the strings from the brief are exact', () {
    expect(GapFillingStrings.introTitle, 'خلّينا نعرف من وين نبدأ');
    expect(GapFillingStrings.strongSkills, 'أحسنت! في مهارات قوية عندك');
    expect(GapFillingStrings.pathTitle, 'مسارك للمراجعة');
    expect(GapFillingStrings.reviewStronger, 'ممتاز! هالمهارة صارت أقوى');
    expect(GapFillingStrings.reviewTryLater,
        'ولا يهمك، المراجعة بتفرق. جرّب مرة ثانية لاحقاً');
    expect(GapFillingStrings.pathInviteTitle, 'اعرف مستواك وابدأ مسارك');
    expect(GapFillingStrings.pathAllGood, 'ممتاز! ما في مهارات بحاجة مراجعة حالياً');
    expect(GapFillingStrings.prerequisitesTitle, 'قبل ما تبدأ، راجع:');
  });

  test('grade labels use the Arabic ordinal', () {
    expect(GapFillingStrings.fromGrade(7), 'من الصف السابع');
    expect(GapFillingStrings.fromGrade(8), 'من الصف الثامن');
  });

  test('time estimates read naturally', () {
    expect(GapFillingStrings.minutes(1), 'حوالي دقيقة');
    expect(GapFillingStrings.minutes(2), 'حوالي دقيقتين');
    expect(GapFillingStrings.minutes(5), 'حوالي 5 دقائق');
  });

  test('the limits match the brief', () {
    expect(Limits.weakSkillThreshold, 60);
    expect(Limits.diagnosticQuestionsPerSkill, 2);
    expect(Limits.diagnosticMaxQuestionsPerSubject, 15);
    expect(Limits.learningPathSize, 3);
  });
}
