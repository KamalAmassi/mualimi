import 'package:mualimi/features/gap_filling/domain/entities/diagnostic_question.dart';
import 'package:mualimi/features/gap_filling/domain/entities/question_kind.dart';
import 'package:mualimi/features/gap_filling/domain/entities/skill.dart';
import 'package:mualimi/features/gap_filling/domain/entities/skill_need.dart';

Skill skill(String id, {int grade = 7, String subject = 'science'}) => Skill(
      id: id,
      subjectId: subject,
      grade: grade,
      title: 'مهارة $id',
      summary: 'ملخص',
      miniLesson: '## عنوان\n\nنص.',
    );

SkillNeed need(String id, int lessons, {int grade = 7, String subject = 'science'}) =>
    SkillNeed(skill: skill(id, grade: grade, subject: subject), lessonCount: lessons);

/// The right choice is always index 1.
DiagnosticQuestion question(
  int id,
  String skillId, {
  QuestionKind kind = QuestionKind.diagnostic,
}) =>
    DiagnosticQuestion(
      id: id,
      skillId: skillId,
      prompt: 'سؤال $id',
      choices: const ['أ', 'ب', 'ج', 'د'],
      answerIndex: 1,
      explanation: 'شرح $id',
      kind: kind,
    );

List<DiagnosticQuestion> questionsOf(String skillId, int from, {int count = 2}) =>
    [for (var i = 0; i < count; i++) question(from + i, skillId)];
