import '../entities/lesson.dart';
import '../repositories/subject_tutor_repository.dart';

/// The tutor is available for a lesson only when both the lesson and its
/// subject enable it.
class IsLessonTutorEnabledUseCase {
  IsLessonTutorEnabledUseCase(this._repository);
  final SubjectTutorRepository _repository;

  Future<bool> call(Lesson lesson) async =>
      lesson.tutorEnabled && await _repository.isTutorEnabled(lesson.subjectId);
}
