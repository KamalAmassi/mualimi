import '../repositories/reading_preferences_repository.dart';

class GetFontScaleUseCase {
  GetFontScaleUseCase(this._repository);
  final ReadingPreferencesRepository _repository;

  double call() => _repository.fontScale;
}
