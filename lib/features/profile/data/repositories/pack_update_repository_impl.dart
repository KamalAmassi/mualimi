import '../../../../core/services/connectivity_service.dart';
import '../../../content_manager/domain/usecases/check_pack_update_usecase.dart';
import '../../domain/entities/pack_update_check.dart';
import '../../domain/repositories/pack_update_repository.dart';

/// The manifest falls back to its cached copy when the fetch fails, so a
/// "current" answer is trusted only while the device reports a network.
class PackUpdateRepositoryImpl implements PackUpdateRepository {
  PackUpdateRepositoryImpl(this._connectivity, this._checkUpdate);
  final ConnectivityService _connectivity;
  final CheckPackUpdateUseCase _checkUpdate;

  @override
  Future<PackUpdateCheck> check(int grade) async {
    if (!_connectivity.isOnline) return PackUpdateCheck.unavailable;
    final result = await _checkUpdate(grade);
    return result.fold(
      (_) => PackUpdateCheck.unavailable,
      (pack) => pack == null ? PackUpdateCheck.upToDate : PackUpdateCheck.updateAvailable,
    );
  }
}