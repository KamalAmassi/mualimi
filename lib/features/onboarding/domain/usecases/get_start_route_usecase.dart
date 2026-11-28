import '../../../../core/routes/app_routes.dart';
import '../../../content_manager/domain/entities/pack_schema_status.dart';
import '../../../content_manager/domain/repositories/installed_content_repository.dart';
import '../repositories/onboarding_repository.dart';

/// Splash rule: finished onboarding with a compatible pack goes straight to
/// the app. A pack the app can no longer read is downloaded again for the
/// stored grade; anything else restarts onboarding.
class GetStartRouteUseCase {
  GetStartRouteUseCase(this._onboarding, this._installed);
  final OnboardingRepository _onboarding;
  final InstalledContentRepository _installed;

  Future<String> call() async {
    if (!_onboarding.isOnboardingDone) return AppRoutes.welcome;
    final schema = await _installed.installedSchemaStatus();
    if (schema == null) return AppRoutes.welcome;
    if (schema == PackSchemaStatus.compatible) return AppRoutes.shell;
    return _onboarding.hasGrade ? AppRoutes.download : AppRoutes.welcome;
  }
}
