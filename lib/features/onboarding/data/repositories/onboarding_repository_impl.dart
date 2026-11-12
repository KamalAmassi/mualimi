import '../../../../core/services/database_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._settings, this._databases);

  final SettingsService _settings;
  final DatabaseService _databases;

  @override
  bool get isOnboardingDone => _settings.onboardingDone.value;

  @override
  Future<bool> isPackInstalled() async =>
      _settings.installedPackVersion.value != null && _databases.hasContent;

  @override
  Future<void> saveStudentName(String name) => _settings.setStudentName(name);

  @override
  Future<void> saveGrade(int grade) => _settings.setGrade(grade);
}
