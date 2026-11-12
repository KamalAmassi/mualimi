import '../repositories/onboarding_repository.dart';

class SaveGradeUseCase {
  SaveGradeUseCase(this._repository);
  final OnboardingRepository _repository;

  Future<void> call(int grade) => _repository.saveGrade(grade);
}
