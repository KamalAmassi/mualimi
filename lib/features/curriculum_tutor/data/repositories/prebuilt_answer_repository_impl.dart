import '../../../../core/error/exceptions.dart';
import '../../domain/entities/quick_action.dart';
import '../../domain/repositories/prebuilt_answer_repository.dart';
import '../datasources/tutor_content_local_data_source.dart';

class PrebuiltAnswerRepositoryImpl implements PrebuiltAnswerRepository {
  PrebuiltAnswerRepositoryImpl(this._content);
  final TutorContentLocalDataSource _content;

  @override
  Future<String?> find(String lessonId, QuickAction action) async {
    try {
      return await _content.prebuiltAnswer(lessonId, action);
    } on DatabaseException {
      return null; // falls back to generating
    }
  }
}
