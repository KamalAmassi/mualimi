import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  GetProfileUseCase(this._repository);
  final ProfileRepository _repository;

  Profile call() => _repository.getProfile();
}
