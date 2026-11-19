import 'package:equatable/equatable.dart';

import 'skill.dart';

class SubjectDiagnosticResult extends Equatable {
  const SubjectDiagnosticResult({
    required this.subjectId,
    required this.subjectName,
    required this.strongSkillCount,
    required this.weakSkills,
  });

  final String subjectId;
  final String subjectName;
  final int strongSkillCount;

  /// Skills that need review, most useful first.
  final List<Skill> weakSkills;

  @override
  List<Object?> get props => [subjectId, subjectName, strongSkillCount, weakSkills];
}
