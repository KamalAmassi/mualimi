import '../../domain/repositories/subject_tutor_repository.dart';
import '../datasources/subject_tutor_local_data_source.dart';

class SubjectTutorRepositoryImpl implements SubjectTutorRepository {
  SubjectTutorRepositoryImpl(this._local);
  final SubjectTutorLocalDataSource _local;

  @override
  Future<bool> isTutorEnabled(String subjectId) async {
    try {
      return await _local.isTutorEnabled(subjectId);
    } on Exception {
      return false;
    } on StateError {
      return false;
    }
  }
}
