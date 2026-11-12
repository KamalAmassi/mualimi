import '../entities/app_theme_mode.dart';
import '../repositories/profile_repository.dart';

class SetThemeModeUseCase {
  SetThemeModeUseCase(this._repository);
  final ProfileRepository _repository;

  Future<void> call(AppThemeMode mode) => _repository.setThemeMode(mode);
}
