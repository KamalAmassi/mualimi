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

  /// The same result keeping only the skills still in [weakSkillIds].
  SubjectDiagnosticResult onlyWeak(Set<String> weakSkillIds) =>
      SubjectDiagnosticResult(
        subjectId: subjectId,
        subjectName: subjectName,
        strongSkillCount: strongSkillCount,
        weakSkills: [
          for (final s in weakSkills)
            if (weakSkillIds.contains(s.id)) s
        ],
      );

  @override
  List<Object?> get props => [subjectId, subjectName, strongSkillCount, weakSkills];
}
