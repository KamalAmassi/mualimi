import '../../../../core/usecase/usecase.dart';
import '../repositories/network_status_repository.dart';

class WatchOnlineUseCase implements StreamUseCase<bool, NoParams> {
  WatchOnlineUseCase(this._repository);
  final NetworkStatusRepository _repository;

  @override
  Stream<bool> call(NoParams params) => _repository.watchOnline();
}
