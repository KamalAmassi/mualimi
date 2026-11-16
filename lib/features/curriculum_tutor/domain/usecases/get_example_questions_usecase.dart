import '../repositories/question_bank_repository.dart';

class GetExampleQuestionsUseCase {
  GetExampleQuestionsUseCase(this._repository);
  final QuestionBankRepository _repository;

  Future<List<String>> call(String subjectId, {String? lessonId}) =>
      _repository.exampleQuestions(subjectId, lessonId: lessonId);
}
