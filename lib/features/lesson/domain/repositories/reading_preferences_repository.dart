abstract class ReadingPreferencesRepository {
  double get fontScale;
  Future<void> saveFontScale(double scale);
}
