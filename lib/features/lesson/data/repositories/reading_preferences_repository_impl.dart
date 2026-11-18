import '../../../../core/services/settings_service.dart';
import '../../domain/repositories/reading_preferences_repository.dart';

/// Uses the app-wide font scale, which the app applies to all text.
class ReadingPreferencesRepositoryImpl implements ReadingPreferencesRepository {
  ReadingPreferencesRepositoryImpl(this._settings);
  final SettingsService _settings;

  @override
  double get fontScale => _settings.fontScale.value;

  @override
  Future<void> saveFontScale(double scale) => _settings.setFontScale(scale);
}
