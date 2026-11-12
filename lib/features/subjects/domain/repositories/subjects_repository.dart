import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/subject.dart';
import '../entities/subject_unit.dart';

abstract class SubjectsRepository {
  Future<Either<Failure, List<Subject>>> getSubjects();
  Future<Either<Failure, Subject>> getSubject(String id);
  Future<Either<Failure, List<SubjectUnit>>> getUnits(String subjectId);
}
