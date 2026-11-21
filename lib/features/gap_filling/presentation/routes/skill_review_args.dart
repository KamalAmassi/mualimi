import 'package:equatable/equatable.dart';

/// Arguments of `AppRoutes.skillReview`: the skill to review and, when it was
/// opened from a lesson, that lesson.
class SkillReviewArgs extends Equatable {
  const SkillReviewArgs({required this.skillId, this.lessonId});

  final String skillId;
  final String? lessonId;

  /// Null when the arguments are missing, of another type or have no skill.
  static SkillReviewArgs? from(Object? arguments) {
    if (arguments is! SkillReviewArgs) return null;
    final skill = arguments.skillId.trim();
    if (skill.isEmpty) return null;
    final lesson = arguments.lessonId?.trim();
    return SkillReviewArgs(
      skillId: skill,
      lessonId: lesson == null || lesson.isEmpty ? null : lesson,
    );
  }

  @override
  List<Object?> get props => [skillId, lessonId];
}
