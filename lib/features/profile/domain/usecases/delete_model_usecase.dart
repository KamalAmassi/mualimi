import '../repositories/model_management_repository.dart';

class DeleteModelUseCase {
  DeleteModelUseCase(this._repository);
  final ModelManagementRepository _repository;

  Future<bool> call() => _repository.deleteModel();
}
