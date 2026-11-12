import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/book_solution.dart';
import '../entities/key_term.dart';
import '../entities/lesson.dart';

abstract class LessonRepository {
  Future<Either<Failure, Lesson>> getLesson(String id);
  Future<Either<Failure, List<KeyTerm>>> getKeyTerms(String lessonId);
  Future<Either<Failure, List<BookSolution>>> getSolutions(String lessonId);

  /// Index of the section the student last read; 0 if none.
  Future<int> getLastSection(String lessonId);
  Future<void> saveProgress(String lessonId, int section);
}
