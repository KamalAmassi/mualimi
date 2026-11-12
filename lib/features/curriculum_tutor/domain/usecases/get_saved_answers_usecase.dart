import '../entities/saved_answer.dart';
import '../repositories/saved_answers_repository.dart';

class GetSavedAnswersUseCase {
  GetSavedAnswersUseCase(this._repository);
  final SavedAnswersRepository _repository;

  Future<List<SavedAnswer>> call() => _repository.all();
}
