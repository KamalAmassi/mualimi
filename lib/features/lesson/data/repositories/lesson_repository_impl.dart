import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/book_solution.dart';
import '../../domain/entities/key_term.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_local_data_source.dart';
import '../datasources/lesson_progress_local_data_source.dart';

class LessonRepositoryImpl implements LessonRepository {
  LessonRepositoryImpl(this._content, this._progress);

  final LessonLocalDataSource _content;
  final LessonProgressLocalDataSource _progress;

  @override
  Future<Either<Failure, Lesson>> getLesson(String id) => _guard(() => _content.lesson(id));

  @override
  Future<Either<Failure, List<KeyTerm>>> getKeyTerms(String lessonId) =>
      _guard(() => _content.keyTerms(lessonId));

  @override
  Future<Either<Failure, List<BookSolution>>> getSolutions(String lessonId) =>
      _guard(() => _content.solutions(lessonId));

  @override
  Future<int> getLastSection(String lessonId) => _progress.lastSection(lessonId);

  @override
  Future<void> saveProgress(String lessonId, int section) => _progress.save(lessonId, section);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() read) async {
    try {
      return Right(await read());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
