import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/key_term.dart';
import '../repositories/lesson_repository.dart';

class GetKeyTermsUseCase implements UseCase<List<KeyTerm>, String> {
  GetKeyTermsUseCase(this._repository);
  final LessonRepository _repository;

  @override
  Future<Either<Failure, List<KeyTerm>>> call(String lessonId) =>
      _repository.getKeyTerms(lessonId);
}
