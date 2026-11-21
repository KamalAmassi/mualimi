import 'package:equatable/equatable.dart';

import '../../../../core/constants/limits.dart';
import 'diagnostic_question.dart';

/// The questions the student answers for one subject, in the order shown.
class SubjectDiagnostic extends Equatable {
  const SubjectDiagnostic({
    required this.subjectId,
    required this.subjectName,
    required this.questions,
    required this.skillIds,
  });

  final String subjectId;
  final String subjectName;
  final List<DiagnosticQuestion> questions;

  /// Every prerequisite skill of the subject, asked or not.
  final List<String> skillIds;

  int get estimatedMinutes =>
      (questions.length * Limits.secondsPerDiagnosticQuestion / 60).ceil();

  @override
  List<Object?> get props => [subjectId, subjectName, questions, skillIds];
}
