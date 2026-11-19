import '../entities/skill_need.dart';

/// Skills that more lessons depend on come first, then lower grades.
abstract final class SkillPriority {
  static int compare(SkillNeed a, SkillNeed b) {
    final byLessons = b.lessonCount.compareTo(a.lessonCount);
    if (byLessons != 0) return byLessons;
    final byGrade = a.skill.grade.compareTo(b.skill.grade);
    if (byGrade != 0) return byGrade;
    return a.skill.id.compareTo(b.skill.id);
  }

  static List<SkillNeed> sorted(Iterable<SkillNeed> needs) =>
      needs.toList()..sort(compare);
}
