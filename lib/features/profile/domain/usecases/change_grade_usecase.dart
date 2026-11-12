import '../repositories/profile_repository.dart';

class ChangeGradeUseCase {
  ChangeGradeUseCase(this._repository);
  final ProfileRepository _repository;

  Future<void> call(int grade) => _repository.changeGrade(grade);
}
