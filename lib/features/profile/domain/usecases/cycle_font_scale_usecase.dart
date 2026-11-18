import '../../../lesson/domain/entities/reading_font_scale.dart';
import '../repositories/profile_repository.dart';

/// Same steps as the lesson viewer's Aa button: both edit the one app-wide scale.
class CycleFontScaleUseCase {
  CycleFontScaleUseCase(this._repository);
  final ProfileRepository _repository;

  Future<double> call() async {
    final next = ReadingFontScale.next(_repository.getProfile().fontScale);
    await _repository.setFontScale(next);
    return next;
  }
}