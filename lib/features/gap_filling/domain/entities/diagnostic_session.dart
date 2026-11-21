import 'package:equatable/equatable.dart';

import 'diagnostic_answer.dart';
import 'diagnostic_attempt.dart';
import 'subject_diagnostic.dart';

/// A diagnostic in progress: the plans plus one open attempt per subject.
class DiagnosticSession extends Equatable {
  const DiagnosticSession({required this.plans, required this.attempts});

  final List<SubjectDiagnostic> plans;

  /// Keyed by subject id.
  final Map<String, DiagnosticAttempt> attempts;

  /// Answers already given, keyed by question id; the session resumes after them.
  Map<int, DiagnosticAnswer> get answered => {
        for (final attempt in attempts.values)
          for (final answer in attempt.answers) answer.questionId: answer,
      };

  @override
  List<Object?> get props => [plans, attempts];
}
