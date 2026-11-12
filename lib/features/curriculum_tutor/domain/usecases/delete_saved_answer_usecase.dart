import '../repositories/saved_answers_repository.dart';

class DeleteSavedAnswerUseCase {
  DeleteSavedAnswerUseCase(this._repository);
  final SavedAnswersRepository _repository;

  Future<void> call(int id) => _repository.delete(id);
}
