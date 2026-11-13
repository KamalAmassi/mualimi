/// Splash-only geometry, copied from design/screens/light/Splash.html
/// (px → logical pixels). Shared spacing lives in `AppSizes`; these values
/// belong to this one screen.
abstract final class SplashDimens {
  // Content
  static const double gap = 14;
  static const double footerBottomPadding = 48;

  // Logo box: CSS width 92 + 1px border on each side (content-box).
  static const double logoBorder = 1;
  static const double logoBox = 92 + 2 * logoBorder;
  static const double logoRadius = 28;

  // Book icon (inline SVG)
  static const double icon = 46;
  static const double iconViewBox = 24;
  static const double iconStroke = 1.7;

  // Text
  static const double nameFontSize = 56;
  static const double nameLineHeight = 1.1;
  static const double taglineFontSize = 16;
  static const double footerFontSize = 12;

  // Progress track
  static const double trackWidth = 120;
  static const double trackHeight = 4;
  static const double trackRadius = 2;
  static const double trackFill = 0.55;

  // Decorative circles (physical offsets, as in the HTML)
  static const double decoSize = 420;
  static const double decoTop = -190;
  static const double decoLeft = -170;

  // Ring: CSS width 300 + 1.5px border on each side (content-box).
  static const double ringBorder = 1.5;
  static const double ringSize = 300 + 2 * ringBorder;
  static const double ringTop = -90;
  static const double ringLeft = -70;
  static const double ringOpacity = 0.7;

  static const double decoDeepSize = 360;
  static const double decoDeepBottom = -200;
  static const double decoDeepRight = -150;
}
