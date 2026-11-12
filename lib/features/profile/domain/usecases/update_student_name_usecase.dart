import '../../../../core/constants/limits.dart';
import '../repositories/profile_repository.dart';

class UpdateStudentNameUseCase {
  UpdateStudentNameUseCase(this._repository);
  final ProfileRepository _repository;

  /// False (nothing saved) for an empty or over-long name.
  Future<bool> call(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > Limits.nameMaxLength) return false;
    await _repository.updateName(trimmed);
    return true;
  }
}
