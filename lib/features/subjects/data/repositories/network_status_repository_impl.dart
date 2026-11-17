import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/network_kind.dart';
import '../../domain/repositories/network_status_repository.dart';

class NetworkStatusRepositoryImpl implements NetworkStatusRepository {
  NetworkStatusRepositoryImpl(this._connectivity);
  final ConnectivityService _connectivity;

  @override
  Stream<bool> watchOnline() async* {
    yield _connectivity.isOnline;
    yield* _connectivity.network.stream.map((kind) => kind != NetworkKind.offline);
  }
}
