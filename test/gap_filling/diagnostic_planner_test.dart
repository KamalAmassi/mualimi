import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/limits.dart';
import 'package:mualimi/features/gap_filling/domain/entities/question_kind.dart';
import 'package:mualimi/features/gap_filling/domain/rules/diagnostic_planner.dart';

import 'gap_filling_fixtures.dart';

const _names = {'science': 'العلوم', 'math': 'الرياضيات', 'arabic': 'العربية'};

void main() {
  test('skills are ordered by dependent lessons, then lower grade', () {
    final plans = DiagnosticPlanner.plan(
      subjectNames: _names,
      needs: [
        need('few', 1, grade: 6),
        need('many-high', 3, grade: 8),
        need('many-low', 3, grade: 6),
      ],
      questions: [
        ...questionsOf('few', 10),
        ...questionsOf('many-high', 20),
        ...questionsOf('many-low', 30),
      ],
    );
    expect(plans.single.skillIds, ['many-low', 'many-high', 'few']);
    expect(plans.single.questions.first.skillId, 'many-low');
  });

  test('each skill gets at most the configured number of diagnostic questions', () {
    final plans = DiagnosticPlanner.plan(
      subjectNames: _names,
      needs: [need('a', 1)],
      questions: [
        ...questionsOf('a', 1, count: 5),
        question(9, 'a', kind: QuestionKind.review),
      ],
    );
    final questions = plans.single.questions;
    expect(questions.length, Limits.diagnosticQuestionsPerSkill);
    expect(questions.every((q) => q.kind == QuestionKind.diagnostic), isTrue);
  });

  test('a subject never gets more than the maximum, earlier skills first', () {
    final needs = [for (var i = 0; i < 10; i++) need('s$i', 10 - i)];
    final questions = [for (var i = 0; i < 10; i++) ...questionsOf('s$i', i * 10)];
    final asked = DiagnosticPlanner.plan(
            subjectNames: _names, needs: needs, questions: questions)
        .single
        .questions;
    expect(asked.length, Limits.diagnosticMaxQuestionsPerSubject);
    final skills = asked.map((q) => q.skillId).toSet();
    expect(skills.contains('s7'), isTrue);
    expect(skills.contains('s8'), isFalse);
    expect(skills.contains('s9'), isFalse);
  });

  test('questions of the same skill are never shown back to back', () {
    final needs = [for (var i = 0; i < 8; i++) need('s$i', 10 - i)];
    final questions = [for (var i = 0; i < 8; i++) ...questionsOf('s$i', i * 10)];
    final asked = DiagnosticPlanner.plan(
            subjectNames: _names, needs: needs, questions: questions)
        .single
        .questions;
    for (var i = 1; i < asked.length; i++) {
      expect(asked[i].skillId, isNot(asked[i - 1].skillId));
    }
  });

  test('uneven question counts still avoid neighbours when another skill is left', () {
    final asked = DiagnosticPlanner.plan(
      subjectNames: _names,
      needs: [need('a', 3), need('b', 2)],
      questions: [question(1, 'a'), question(2, 'a'), question(3, 'b')],
    ).single.questions;
    expect(asked.map((q) => q.skillId), ['a', 'b', 'a']);
  });

  test('only subjects with prerequisite skills have a diagnostic', () {
    final plans = DiagnosticPlanner.plan(
      subjectNames: _names,
      needs: [need('m', 1, subject: 'math'), need('s', 1)],
      questions: [...questionsOf('m', 1), ...questionsOf('s', 10)],
    );
    expect(plans.map((p) => p.subjectId), ['science', 'math']);
  });

  test('math is included when it has skills, and a subject without questions is not', () {
    final plans = DiagnosticPlanner.plan(
      subjectNames: _names,
      needs: [need('m', 1, subject: 'math'), need('a', 1, subject: 'arabic')],
      questions: questionsOf('m', 1),
    );
    expect(plans.map((p) => p.subjectId), ['math']);
  });

  test('the estimate is about 30 seconds per question', () {
    final plan = DiagnosticPlanner.plan(
      subjectNames: _names,
      needs: [need('a', 1), need('b', 1)],
      questions: [...questionsOf('a', 1), ...questionsOf('b', 10)],
    ).single;
    expect(plan.questions.length, 4);
    expect(plan.estimatedMinutes, 2);
  });
}
