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
  Future<Either<Failure, ContinueLesson?>> getContinueLesson() => _guard(_local.continueLesson);

  @override
  Future<Either<Failure, String?>> getLastOpenedLessonId(String subjectId) =>
      _guard(() => _local.lastOpenedLessonId(subjectId));

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() read) async {
    try {
      return Right(await read());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
