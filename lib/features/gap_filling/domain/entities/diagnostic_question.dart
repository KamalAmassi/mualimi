import 'package:equatable/equatable.dart';

import 'question_kind.dart';

class DiagnosticQuestion extends Equatable {
  const DiagnosticQuestion({
    required this.id,
    required this.skillId,
    required this.prompt,
    required this.choices,
    required this.answerIndex,
    required this.explanation,
    required this.kind,
  });

  final int id;
  final String skillId;
  final String prompt;
  final List<String> choices;
  final int answerIndex;
  final String explanation;
  final QuestionKind kind;

  /// A null [choice] means the student chose "I do not know".
  bool isCorrect(int? choice) => choice == answerIndex;

  @override
  List<Object?> get props =>
      [id, skillId, prompt, choices, answerIndex, explanation, kind];
}
