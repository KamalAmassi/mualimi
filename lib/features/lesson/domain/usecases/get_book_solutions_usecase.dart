import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/book_solution.dart';
import '../repositories/lesson_repository.dart';

class GetBookSolutionsUseCase implements UseCase<List<BookSolution>, String> {
  GetBookSolutionsUseCase(this._repository);
  final LessonRepository _repository;

  @override
  Future<Either<Failure, List<BookSolution>>> call(String lessonId) =>
      _repository.getSolutions(lessonId);
}
