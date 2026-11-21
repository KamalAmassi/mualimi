import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/limits.dart';
import 'package:mualimi/features/gap_filling/domain/entities/diagnostic_answer.dart';
import 'package:mualimi/features/gap_filling/domain/entities/mastery_source.dart';
import 'package:mualimi/features/gap_filling/domain/entities/mini_lesson_block.dart';
import 'package:mualimi/features/gap_filling/domain/entities/skill_mastery.dart';
import 'package:mualimi/features/gap_filling/domain/entities/subject_diagnostic.dart';
import 'package:mualimi/features/gap_filling/domain/rules/diagnostic_scorer.dart';
import 'package:mualimi/features/gap_filling/domain/rules/learning_path_builder.dart';
import 'package:mualimi/features/gap_filling/domain/rules/mini_lesson_parser.dart';
import 'package:mualimi/features/gap_filling/domain/rules/review_scorer.dart';

import 'gap_filling_fixtures.dart';

final _now = DateTime(2026, 11, 19);

SkillMastery _mastery(String id, int score) => SkillMastery(
    skillId: id, score: score, source: MasterySource.diagnostic, updatedAt: _now);

void main() {
  group('DiagnosticScorer', () {
    final plan = SubjectDiagnostic(
      subjectId: 'science',
      subjectName: 'العلوم',
      questions: [question(1, 'a'), question(2, 'b'), question(3, 'a'), question(4, 'b')],
      skillIds: const ['a', 'b', 'c'],
    );

    Map<int, DiagnosticAnswer> answers(Map<int, int?> byQuestion) => {
          for (final e in byQuestion.entries)
            e.key: DiagnosticAnswer(questionId: e.key, choiceIndex: e.value),
        };

    test('the score is the rounded percentage of correct answers per skill', () {
      final result = DiagnosticScorer.score(
          plan, answers({1: 1, 2: 0, 3: 0, 4: 0}), _now);
      final byId = {for (final m in result) m.skillId: m};
      expect(byId['a']!.score, 50);
      expect(byId['b']!.score, 0);
      expect(byId['a']!.source, MasterySource.diagnostic);
    });

    test('"I do not know" counts as wrong', () {
      final result = DiagnosticScorer.score(
          plan, answers({1: null, 2: 1, 3: null, 4: 1}), _now);
      final byId = {for (final m in result) m.skillId: m.score};
      expect(byId, {'a': 0, 'b': 100});
    });

    test('a skill that was not asked has no mastery row', () {
      final result = DiagnosticScorer.score(plan, answers({1: 1, 3: 1}), _now);
      expect(result.map((m) => m.skillId), ['a']);
    });

    test('one of three correct rounds to 33', () {
      expect(DiagnosticScorer.percent(1, 3), 33);
      expect(DiagnosticScorer.percent(2, 3), 67);
    });
  });

  group('weak threshold', () {
    test('a score below the threshold is weak, at the threshold it is not', () {
      expect(_mastery('a', Limits.weakSkillThreshold - 1).isWeak, isTrue);
      expect(_mastery('a', Limits.weakSkillThreshold).isWeak, isFalse);
    });
  });

  group('LearningPathBuilder', () {
    final needs = [
      need('few', 1, grade: 6),
      need('many-high', 3, grade: 8),
      need('many-low', 3, grade: 7),
      need('strong', 5),
      need('unasked', 9),
    ];

    test('weak skills come by dependent lessons, then lower grade', () {
      final weak = LearningPathBuilder.weakSkills(needs, [
        _mastery('few', 0),
        _mastery('many-high', 40),
        _mastery('many-low', 50),
        _mastery('strong', 100),
      ]);
      expect(weak.map((s) => s.id), ['many-low', 'many-high', 'few']);
    });

    test('a skill without a mastery row is not weak', () {
      final weak = LearningPathBuilder.weakSkills(needs, [_mastery('few', 10)]);
      expect(weak.map((s) => s.id), ['few']);
    });

    test('mastery of skills outside the needs is ignored', () {
      expect(LearningPathBuilder.weakSkills([need('a', 1)], [_mastery('gone', 0)]),
          isEmpty);
    });
  });

  group('ReviewScorer', () {
    test('the new score is the better of the old score and the review', () {
      expect(ReviewScorer.nextScore(old: 0, correct: 2, asked: 2), 100);
      expect(ReviewScorer.nextScore(old: 50, correct: 0, asked: 2), 50);
      expect(ReviewScorer.nextScore(old: 50, correct: 1, asked: 2), 50);
      expect(ReviewScorer.nextScore(correct: 1, asked: 2), 50);
    });

    test('weak follows the threshold', () {
      expect(ReviewScorer.isWeak(Limits.weakSkillThreshold - 1), isTrue);
      expect(ReviewScorer.isWeak(Limits.weakSkillThreshold), isFalse);
    });
  });

  group('MiniLessonParser', () {
    test('reads headings, paragraphs, list items and callouts as plain text', () {
      final blocks = MiniLessonParser.parse(
          '## عنوان\n\nفقرة **مهمة**.\n\n- أول\n- ثان\n\n> **تذكّر:** انتبه.');
      expect(blocks, const [
        MiniLessonBlock(MiniLessonBlockKind.heading, 'عنوان'),
        MiniLessonBlock(MiniLessonBlockKind.paragraph, 'فقرة مهمة.'),
        MiniLessonBlock(MiniLessonBlockKind.bullet, 'أول'),
        MiniLessonBlock(MiniLessonBlockKind.bullet, 'ثان'),
        MiniLessonBlock(MiniLessonBlockKind.callout, 'تذكّر: انتبه.'),
      ]);
    });

    test('an empty lesson has no blocks', () {
      expect(MiniLessonParser.parse(''), isEmpty);
    });
  });
}
