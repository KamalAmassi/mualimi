import 'dart:convert';

import '../../../../core/db/content/content_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/diagnostic_question.dart';
import '../../domain/entities/question_kind.dart';

class DiagnosticQuestionModel extends DiagnosticQuestion {
  const DiagnosticQuestionModel._({
    required super.id,
    required super.skillId,
    required super.prompt,
    required super.choices,
    required super.answerIndex,
    required super.explanation,
    required super.kind,
  });

  factory DiagnosticQuestionModel.fromRow(DiagnosticQuestionRow row) {
    final decoded = jsonDecode(row.choicesJson);
    if (decoded is! List ||
        row.answerIndex < 0 ||
        row.answerIndex >= decoded.length) {
      throw DatabaseException('question ${row.id} has invalid choices');
    }
    return DiagnosticQuestionModel._(
      id: row.id,
      skillId: row.skillId,
      prompt: row.prompt,
      choices: [for (final c in decoded) '$c'],
      answerIndex: row.answerIndex,
      explanation: row.explanation,
      kind: QuestionKind.parse(row.kind),
    );
  }
}
