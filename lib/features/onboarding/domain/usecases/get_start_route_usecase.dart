import '../../../../core/routes/app_routes.dart';
import '../repositories/onboarding_repository.dart';

/// Splash rule: finished onboarding with an installed pack goes straight to
/// the app; anything else restarts onboarding.
class GetStartRouteUseCase {
  GetStartRouteUseCase(this._repository);
  final OnboardingRepository _repository;

  Future<String> call() async {
    final ready = _repository.isOnboardingDone && await _repository.isPackInstalled();
    return ready ? AppRoutes.shell : AppRoutes.welcome;
  }
}
