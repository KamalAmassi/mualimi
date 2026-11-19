import 'package:equatable/equatable.dart';

import 'skill.dart';

/// A skill that lessons of the installed grade depend on.
class SkillNeed extends Equatable {
  const SkillNeed({required this.skill, required this.lessonCount});

  final Skill skill;

  /// How many lessons list this skill as a prerequisite.
  final int lessonCount;

  @override
  List<Object?> get props => [skill, lessonCount];
}
