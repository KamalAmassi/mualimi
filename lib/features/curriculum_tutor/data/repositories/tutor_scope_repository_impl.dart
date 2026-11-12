import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/tutor_scope_repository.dart';
import '../datasources/tutor_content_local_data_source.dart';

class TutorScopeRepositoryImpl implements TutorScopeRepository {
  TutorScopeRepositoryImpl(this._content);
  final TutorContentLocalDataSource _content;

  @override
  Future<bool> isTutorEnabled(String subjectId, {String? lessonId}) async {
    try {
      return await _content.isTutorEnabled(subjectId, lessonId: lessonId);
    } on DatabaseException {
      return false; // no pack installed: nothing for the tutor to answer from
    }
  }
}
