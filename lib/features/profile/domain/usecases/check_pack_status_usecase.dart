import '../entities/pack_update_check.dart';
import '../repositories/pack_update_repository.dart';

class CheckPackStatusUseCase {
  CheckPackStatusUseCase(this._repository);
  final PackUpdateRepository _repository;

  Future<PackUpdateCheck> call(int? grade) async =>
      grade == null ? PackUpdateCheck.unavailable : _repository.check(grade);
}