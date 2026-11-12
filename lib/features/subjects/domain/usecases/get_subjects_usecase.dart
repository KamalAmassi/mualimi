import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/subject.dart';
import '../repositories/subjects_repository.dart';

class GetSubjectsUseCase implements UseCase<List<Subject>, NoParams> {
  GetSubjectsUseCase(this._repository);
  final SubjectsRepository _repository;

  @override
  Future<Either<Failure, List<Subject>>> call(NoParams params) => _repository.getSubjects();
}
