import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/continue_lesson.dart';

abstract class ContinueLessonRepository {
  /// Null when no opened lesson exists in the installed pack.
  Future<Either<Failure, ContinueLesson?>> getContinueLesson();
}
