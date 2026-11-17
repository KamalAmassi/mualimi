import '../repositories/reading_preferences_repository.dart';

class SaveFontScaleUseCase {
  SaveFontScaleUseCase(this._repository);
  final ReadingPreferencesRepository _repository;

  Future<void> call(double scale) => _repository.saveFontScale(scale);
}
