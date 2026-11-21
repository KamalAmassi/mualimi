import 'package:equatable/equatable.dart';

import '../../../../core/constants/limits.dart';
import 'skill.dart';

class LearningPath extends Equatable {
  const LearningPath({required this.diagnosticTaken, required this.weakSkills});

  final bool diagnosticTaken;

  /// All skills that need review, most useful first.
  final List<Skill> weakSkills;

  List<Skill> get shown => weakSkills.take(Limits.learningPathSize).toList();

  @override
  List<Object?> get props => [diagnosticTaken, weakSkills];
}
