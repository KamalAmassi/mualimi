import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class WatchProfileUseCase {
  WatchProfileUseCase(this._repository);
  final ProfileRepository _repository;

  Stream<Profile> call() => _repository.watchProfile();
}