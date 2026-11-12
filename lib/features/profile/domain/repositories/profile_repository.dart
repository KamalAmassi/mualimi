import '../entities/app_theme_mode.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Profile getProfile();
  Future<void> updateName(String name);
  Future<void> changeGrade(int grade);
  Future<void> setThemeMode(AppThemeMode mode);
}
