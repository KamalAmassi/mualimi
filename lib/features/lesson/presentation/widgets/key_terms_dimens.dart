/// Key terms geometry, copied from design/screens/light/KeyTerms.html
/// (px → logical pixels), except the card back, which the design does not
/// show. Shared spacing lives in `AppSizes`.
abstract final class KeyTermsDimens {
  static const double headerTopPadding = 12;
  static const double headerSidePadding = 12;
  static const double headerBottomPadding = 10;
  static const double headerBorder = 1;
  static const double backSize = 44;
  static const double backRadius = 12;
  static const double backIcon = 22;
  static const double titleFontSize = 18;
  static const double titleLineHeight = 1.35;
  static const double subtitleFontSize = 12;
  static const double subtitleGap = 2;

  static const double bodyVerticalPadding = 18;
  static const double bodyGap = 16;

  static const double cardRadius = 24;
  static const double cardMinHeight = 220;
  static const double cardPadding = 22;
  static const double cardGap = 10;
  static const double cardMetaFontSize = 13;
  static const double cardTermFontSize = 30;
  static const double backTermFontSize = 15;
  static const double backDefinitionFontSize = 17;
  static const double backDefinitionLineHeight = 1.7;
  static const Duration flipDuration = Duration(milliseconds: 300);
  static const double flipPerspective = 0.001;

  static const double navHeight = 50;
  static const double navRadius = 14;
  static const double navBorder = 1.5;
  static const double navFontSize = 15;
  static const double navIcon = 18;
  static const double navIconGap = 8;
  static const double navGap = 10;
  static const double disabledOpacity = 0.5;

  static const double allTermsTopGap = 4;
  static const double allTermsFontSize = 16;

  static const double listRadius = 18;
  static const double listBorder = 1;
  static const double rowVerticalPadding = 12;
  static const double rowHorizontalPadding = 14;
  static const double rowTermFontSize = 15;
  static const double rowDefinitionFontSize = 13.5;
  static const double rowDefinitionLineHeight = 1.7;
}
