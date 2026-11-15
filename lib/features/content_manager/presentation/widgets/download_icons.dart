// SVG path data (24×24 viewBox, stroked) for the download screens.
// Extracted by script from design/screens/light/Download*.html.
abstract final class DownloadIcons {
  /// Header back chevron (points right in RTL).
  static const String chevron = 'M9 6l6 6-6 6';

  /// Pack box shown in the hero chip.
  static const String box = 'M3 8h18v12H3z M3 8l2-4h14l2 4 M10 12h4';

  /// Check mark inside a done step.
  static const String check = 'M5 12l5 5 9-10';

  /// X mark inside a failed step.
  static const String close = 'M6 6l12 12 M18 6L6 18';

  /// Pause (two bars).
  static const String pause = 'M9 5v14 M15 5v14';

  /// Circular refresh / resume arrow.
  static const String refresh = 'M20 12a8 8 0 1 1-2.3-5.7 M20 4v4h-4';

  /// Info circle.
  static const String info = 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18z M12 11v5 M12 8h.01';

  /// Crossed-out Wi-Fi (connection lost).
  static const String wifiOff = 'M2 2l20 20 M8.5 16.5a5 5 0 0 1 7 0 M5 12.9a10 10 0 0 1 5.2-2.8 M19 12.9a10 10 0 0 0-2.7-1.9 M12 20h.01';

  /// Phone outline (not enough storage).
  static const String phone = 'M7 3h10a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1z M11 18h2';

  /// Shield with a check (integrity check).
  static const String shieldCheck = 'M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z M8.5 12l2.5 2.5 4.5-5';

  /// Download arrow into a tray.
  static const String download = 'M12 3v12 M7 10l5 5 5-5 M5 21h14';
}
