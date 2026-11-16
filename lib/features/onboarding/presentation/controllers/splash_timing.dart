/// Splash-only timing. The splash stays on screen at least [minDisplay],
/// even when the start-route check finishes sooner.
abstract final class SplashTiming {
  static const Duration minDisplay = Duration(milliseconds: 1500);
}
