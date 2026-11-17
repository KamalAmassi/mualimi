/// Text sizes the Aa button cycles through in the lesson viewer.
abstract final class ReadingFontScale {
  static const steps = [1.0, 1.15, 1.3];

  /// The first step above [current], wrapping to the smallest. A saved value
  /// that is not a step (set elsewhere) moves to the next step above it.
  static double next(double current) =>
      steps.firstWhere((step) => step > current + 0.001, orElse: () => steps.first);
}
