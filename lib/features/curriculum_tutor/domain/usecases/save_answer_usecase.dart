import '../entities/saved_answer.dart';
import '../repositories/saved_answers_repository.dart';

class SaveAnswerUseCase {
  SaveAnswerUseCase(this._repository);
  final SavedAnswersRepository _repository;

  Future<void> call(SavedAnswer answer) => _repository.save(answer);
}
