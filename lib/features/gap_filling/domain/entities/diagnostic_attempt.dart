import 'package:equatable/equatable.dart';

import 'diagnostic_answer.dart';

class DiagnosticAttempt extends Equatable {
  const DiagnosticAttempt({
    required this.id,
    required this.subjectId,
    required this.startedAt,
    this.finishedAt,
    this.answers = const [],
  });

  final int id;
  final String subjectId;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final List<DiagnosticAnswer> answers;

  @override
  List<Object?> get props => [id, subjectId, startedAt, finishedAt, answers];
}
