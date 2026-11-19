import 'dart:convert';

import '../../../../core/db/user/user_database.dart' show DiagnosticAttemptRow;
import '../../domain/entities/diagnostic_answer.dart';
import '../../domain/entities/diagnostic_attempt.dart';

class DiagnosticAttemptModel extends DiagnosticAttempt {
  DiagnosticAttemptModel.fromRow(DiagnosticAttemptRow row)
      : super(
          id: row.id,
          subjectId: row.subjectId,
          startedAt: row.startedAt,
          finishedAt: row.finishedAt,
          answers: decodeAnswers(row.answersJson),
        );

  static String encodeAnswers(List<DiagnosticAnswer> answers) => jsonEncode([
        for (final a in answers)
          {'question_id': a.questionId, 'choice_index': a.choiceIndex},
      ]);

  /// Unreadable stored answers count as none, so the questions are asked again.
  static List<DiagnosticAnswer> decodeAnswers(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is! List) return const [];
      return [
        for (final item in decoded)
          DiagnosticAnswer(
            questionId: item['question_id'] as int,
            choiceIndex: item['choice_index'] as int?,
          ),
      ];
    } on Object {
      return const [];
    }
  }
}
