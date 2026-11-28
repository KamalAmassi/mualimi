import '../../../../core/services/settings_service.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._settings);

  final SettingsService _settings;

  @override
  bool get isOnboardingDone => _settings.onboardingDone.value;

  @override
  bool get hasGrade => _settings.grade.value != null;

  @override
  Future<void> saveStudentName(String name) => _settings.setStudentName(name);

  @override
  Future<void> saveGrade(int grade) => _settings.setGrade(grade);
}
