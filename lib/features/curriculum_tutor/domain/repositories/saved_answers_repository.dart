import '../entities/saved_answer.dart';

abstract class SavedAnswersRepository {
  Future<void> save(SavedAnswer answer);
  Future<List<SavedAnswer>> all();
  Future<void> delete(int id);
}
