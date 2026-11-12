import '../../../../core/services/tutor_engine_service.dart';
import '../../domain/repositories/model_management_repository.dart';

class ModelManagementRepositoryImpl implements ModelManagementRepository {
  ModelManagementRepositoryImpl(this._engine);
  final TutorEngineService _engine;

  @override
  Future<bool> deleteModel() => _engine.deleteModel();
}
