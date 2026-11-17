import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/continue_lesson.dart';
import '../repositories/continue_lesson_repository.dart';

/// Null when the student has not opened any lesson of the installed pack yet.
class GetContinueLessonUseCase implements UseCase<ContinueLesson?, NoParams> {
  GetContinueLessonUseCase(this._repository);
  final ContinueLessonRepository _repository;

  @override
  Future<Either<Failure, ContinueLesson?>> call(NoParams params) =>
      _repository.getContinueLesson();
}
