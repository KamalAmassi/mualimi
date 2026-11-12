import '../../../../core/constants/limits.dart';
import '../repositories/onboarding_repository.dart';

class SaveStudentNameUseCase {
  SaveStudentNameUseCase(this._repository);
  final OnboardingRepository _repository;

  /// Returns false (saving nothing) for an empty or over-long name.
  Future<bool> call(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > Limits.nameMaxLength) return false;
    await _repository.saveStudentName(trimmed);
    return true;
  }
}
