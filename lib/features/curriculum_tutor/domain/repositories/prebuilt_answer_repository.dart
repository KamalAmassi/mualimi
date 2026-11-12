import '../entities/quick_action.dart';

abstract class PrebuiltAnswerRepository {
  Future<String?> find(String lessonId, QuickAction action);
}
