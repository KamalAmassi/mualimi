import 'package:equatable/equatable.dart';

/// Arguments of `AppRoutes.tutor`: the subject to ask about and, optionally, a lesson.
class TutorArgs extends Equatable {
  const TutorArgs({required this.subjectId, this.lessonId});

  final String subjectId;
  final String? lessonId;

  /// Reads route arguments; null when they are missing, of another type, or
  /// have no subject. A blank lesson id means no lesson.
  static TutorArgs? from(Object? arguments) {
    if (arguments is! TutorArgs) return null;
    final subject = arguments.subjectId.trim();
    if (subject.isEmpty) return null;
    final lesson = arguments.lessonId?.trim();
    return TutorArgs(
      subjectId: subject,
      lessonId: lesson == null || lesson.isEmpty ? null : lesson,
    );
  }

  @override
  List<Object?> get props => [subjectId, lessonId];
}
