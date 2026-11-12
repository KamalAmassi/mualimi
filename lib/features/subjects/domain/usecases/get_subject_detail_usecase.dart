import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/subject.dart';
import '../entities/subject_unit.dart';
import '../repositories/subjects_repository.dart';

class SubjectDetail extends Equatable {
  const SubjectDetail(this.subject, this.units);
  final Subject subject;
  final List<SubjectUnit> units;

  @override
  List<Object?> get props => [subject, units];
}

class GetSubjectDetailUseCase implements UseCase<SubjectDetail, String> {
  GetSubjectDetailUseCase(this._repository);
  final SubjectsRepository _repository;

  @override
  Future<Either<Failure, SubjectDetail>> call(String subjectId) async {
    final subject = await _repository.getSubject(subjectId);
    final units = await _repository.getUnits(subjectId);
    return subject.flatMap((s) => units.map((u) => SubjectDetail(s, u)));
  }
}
