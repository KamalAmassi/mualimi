import 'package:equatable/equatable.dart';

import '../../../../core/constants/limits.dart';
import 'mastery_source.dart';

class SkillMastery extends Equatable {
  const SkillMastery({
    required this.skillId,
    required this.score,
    required this.source,
    required this.updatedAt,
  });

  final String skillId;

  /// 0 to 100.
  final int score;
  final MasterySource source;
  final DateTime updatedAt;

  bool get isWeak => score < Limits.weakSkillThreshold;

  @override
  List<Object?> get props => [skillId, score, source, updatedAt];
}
