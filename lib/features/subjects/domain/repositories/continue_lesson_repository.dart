import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/continue_lesson.dart';

abstract class ContinueLessonRepository {
  /// Null when no opened lesson exists in the installed pack.
  Future<Either<Failure, ContinueLesson?>> getContinueLesson();

  /// Id of the most recently opened lesson of [subjectId]; null when none.
  Future<Either<Failure, String?>> getLastOpenedLessonId(String subjectId);
}
