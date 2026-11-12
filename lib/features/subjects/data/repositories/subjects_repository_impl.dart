import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/subject_unit.dart';
import '../../domain/repositories/subjects_repository.dart';
import '../datasources/subjects_local_data_source.dart';

class SubjectsRepositoryImpl implements SubjectsRepository {
  SubjectsRepositoryImpl(this._local);
  final SubjectsLocalDataSource _local;

  @override
  Future<Either<Failure, List<Subject>>> getSubjects() => _guard(_local.subjects);

  @override
  Future<Either<Failure, Subject>> getSubject(String id) => _guard(() => _local.subject(id));

  @override
  Future<Either<Failure, List<SubjectUnit>>> getUnits(String subjectId) =>
      _guard(() => _local.units(subjectId));

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() read) async {
    try {
      return Right(await read());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
