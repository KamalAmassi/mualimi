import '../entities/app_theme_mode.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Profile getProfile();

  /// Emits the current profile, then again whenever any of its settings change.
  Stream<Profile> watchProfile();
  Future<void> updateName(String name);
  Future<void> changeGrade(int grade);
  Future<void> setThemeMode(AppThemeMode mode);
  Future<void> setFontScale(double scale);
}