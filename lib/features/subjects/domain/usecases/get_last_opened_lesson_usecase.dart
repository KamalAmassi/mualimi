import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/continue_lesson_repository.dart';

/// Id of the lesson of a subject the student opened most recently; null when none.
class GetLastOpenedLessonUseCase implements UseCase<String?, String> {
  GetLastOpenedLessonUseCase(this._repository);
  final ContinueLessonRepository _repository;

  @override
  Future<Either<Failure, String?>> call(String subjectId) =>
      _repository.getLastOpenedLessonId(subjectId);
}
