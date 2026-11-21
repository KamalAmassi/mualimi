/// A question as (prompt, choices, index of the right choice, explanation).
typedef DevSeedSkillQuestion = (String, List<String>, int, String);

/// Development data of one prerequisite skill with its mini lesson and the
/// two diagnostic and two review questions.
class DevSeedSkill {
  const DevSeedSkill({
    required this.id,
    required this.subjectId,
    required this.grade,
    required this.title,
    required this.summary,
    required this.miniLesson,
    required this.diagnostic,
    required this.review,
  });

  final String id;
  final String subjectId;
  final int grade;
  final String title;
  final String summary;
  final String miniLesson;
  final List<DevSeedSkillQuestion> diagnostic;
  final List<DevSeedSkillQuestion> review;
}
