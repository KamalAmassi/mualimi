import 'package:equatable/equatable.dart';

import 'diagnostic_question.dart';
import 'skill.dart';

class SkillReview extends Equatable {
  const SkillReview({required this.skill, required this.questions});

  final Skill skill;
  final List<DiagnosticQuestion> questions;

  @override
  List<Object?> get props => [skill, questions];
}
