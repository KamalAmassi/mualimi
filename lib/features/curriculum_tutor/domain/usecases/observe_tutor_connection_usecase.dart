import '../repositories/tutor_connection_repository.dart';

class ObserveTutorConnectionUseCase {
  ObserveTutorConnectionUseCase(this._repository);
  final TutorConnectionRepository _repository;

  Stream<bool> call() => _repository.onlineChanges;
}
