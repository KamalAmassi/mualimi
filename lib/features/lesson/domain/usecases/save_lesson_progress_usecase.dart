import '../repositories/lesson_repository.dart';

class SaveLessonProgressUseCase {
  SaveLessonProgressUseCase(this._repository);
  final LessonRepository _repository;

  Future<void> call(String lessonId, int section) =>
      _repository.saveProgress(lessonId, section);
}
