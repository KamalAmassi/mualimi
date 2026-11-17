import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/continue_lesson.dart';
import '../../domain/repositories/continue_lesson_repository.dart';
import '../datasources/subjects_local_data_source.dart';

class ContinueLessonRepositoryImpl implements ContinueLessonRepository {
  ContinueLessonRepositoryImpl(this._local);
  final SubjectsLocalDataSource _local;

  @override
  Future<Either<Failure, ContinueLesson?>> getContinueLesson() async {
    try {
      return Right(await _local.continueLesson());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
