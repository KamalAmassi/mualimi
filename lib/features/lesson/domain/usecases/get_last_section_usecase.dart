import '../repositories/lesson_repository.dart';

class GetLastSectionUseCase {
  GetLastSectionUseCase(this._repository);
  final LessonRepository _repository;

  Future<int> call(String lessonId) => _repository.getLastSection(lessonId);
}
