import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/network_kind.dart';
import '../../../../core/services/tutor_engine_service.dart';
import '../../domain/repositories/tutor_connection_repository.dart';

class TutorConnectionRepositoryImpl implements TutorConnectionRepository {
  TutorConnectionRepositoryImpl(this._engine, this._connectivity);

  final TutorEngineService _engine;
  final ConnectivityService _connectivity;

  @override
  bool get isOnline => _connectivity.isOnline;

  @override
  bool get isConfigured => _engine.isConfigured;

  @override
  Stream<bool> get onlineChanges => _connectivity.network.stream
      .map((kind) => kind != NetworkKind.offline)
      .where((o) => o);
}
