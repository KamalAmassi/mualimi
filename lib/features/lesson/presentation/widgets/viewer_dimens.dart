import 'package:flutter/widgets.dart';

/// Viewer measurements from design/screens/light/Viewer.html.
abstract final class ViewerDimens {
  static const headerPadding = EdgeInsets.all(12);
  static const headerGap = 8.0;
  static const headerTapTarget = 44.0;
  static const headerIcon = 22.0;
  static const titleSize = 15.0;
  static const counterSize = 12.0;

  static const tabStripPadding = EdgeInsets.fromLTRB(16, 0, 16, 12);
  static const tabTrackRadius = 12.0;
  static const tabTrackPadding = EdgeInsets.all(4);
  static const tabMinHeight = 36.0;
  static const tabRadius = 9.0;
  static const tabTextSize = 13.0;

  static const articlePadding = EdgeInsets.symmetric(horizontal: 22, vertical: 20);
  static const articleGap = 14.0;
  static const headingSize = 20.0;
  static const bodySize = 16.0;
  static const bodyLineHeight = 1.95;

  static const footerPadding = EdgeInsets.fromLTRB(16, 12, 16, 16);
  static const footerGap = 10.0;
  static const buttonHeight = 48.0;
  static const buttonPadding = EdgeInsets.symmetric(horizontal: 16);
  static const buttonRadius = 14.0;
  static const buttonTextSize = 14.0;
  static const buttonIcon = 18.0;
  static const buttonIconGap = 6.0;
  static const explainIconGap = 8.0;

  static const dividerWidth = 1.0;
  static const disabledOpacity = 0.5;

  /// The header, tab bar and footer have fixed slots; past this text scale
  /// their labels stop growing while the article keeps scaling.
  static const chromeMaxTextScale = 1.3;
}
