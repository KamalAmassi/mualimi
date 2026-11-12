import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/lesson.dart';
import '../repositories/lesson_repository.dart';

class GetLessonUseCase implements UseCase<Lesson, String> {
  GetLessonUseCase(this._repository);
  final LessonRepository _repository;

  @override
  Future<Either<Failure, Lesson>> call(String lessonId) => _repository.getLesson(lessonId);
}
