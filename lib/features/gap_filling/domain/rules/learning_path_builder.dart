import '../entities/skill.dart';
import '../entities/skill_mastery.dart';
import '../entities/skill_need.dart';
import 'skill_priority.dart';

abstract final class LearningPathBuilder {
  /// The skills among [needs] whose recorded mastery is weak, most useful
  /// first. A skill without a mastery row was never asked and is not weak.
  static List<Skill> weakSkills(
      List<SkillNeed> needs, List<SkillMastery> mastery) {
    final weakIds = {
      for (final m in mastery)
        if (m.isWeak) m.skillId
    };
    return [
      for (final need in SkillPriority.sorted(needs))
        if (weakIds.contains(need.skill.id)) need.skill,
    ];
  }
}
