import 'package:flutter/widgets.dart';

/// Lesson hub measurements from design/screens/light/Lesson.html and the
/// tutor-unavailable card of LessonMath.html.
abstract final class LessonHubDimens {
  static const headerPadding = EdgeInsets.fromLTRB(12, 12, 12, 10);
  static const headerGap = 8.0;
  static const headerBorder = 1.0;
  static const headerTapTarget = 44.0;
  static const headerTapRadius = 12.0;
  static const headerIcon = 22.0;
  static const titleSize = 18.0;
  static const titleLineHeight = 1.35;
  static const titleMaxLines = 2;
  static const subtitleSize = 12.0;
  static const subtitleGap = 2.0;
  static const subtitleMaxLines = 2;

  static const bodyPadding = EdgeInsets.all(16);
  static const sectionGap = 22.0;
  static const sectionInnerGap = 10.0;
  static const sectionTitleSize = 17.0;
  static const sectionCountSize = 13.0;

  static const fileCardPadding = EdgeInsets.all(12);
  static const fileCardRadius = 16.0;
  static const fileCardBorder = 1.0;
  static const fileCardGap = 12.0;
  static const fileTileSize = 44.0;
  static const fileTileRadius = 12.0;
  static const fileTileIcon = 22.0;
  static const fileTitleSize = 15.0;
  static const fileMetaSize = 12.0;
  static const fileChevron = 20.0;

  static const termCardWidth = 220.0;
  static const termCardRadius = 16.0;
  static const termCardPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 12);
  static const termCardGap = 10.0;
  static const termSize = 14.0;
  static const termLineHeight = 1.5;
  static const termDefinitionGap = 4.0;
  static const definitionSize = 13.0;
  static const definitionLineHeight = 1.6;
  static const definitionMaxLines = 2;

  /// Rounding room so glyph metrics never overflow the computed card height.
  static const termCardSlack = 4.0;

  static const barMargin = EdgeInsets.fromLTRB(16, 0, 16, 22);
  static const barMinHeight = 58.0;
  static const barPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const barRadius = 18.0;
  static const barBorder = 1.0;
  static const barGap = 12.0;
  static const barShadowOffset = Offset(0, 10);
  static const barShadowBlur = 28.0;
  static const barTileSize = 36.0;
  static const barTileRadius = 12.0;
  static const barTileIcon = 20.0;
  static const barTitleSize = 15.0;
  static const barSubtitleSize = 12.0;
  static const barChevron = 20.0;
  static const chipPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 4);
  static const chipRadius = 999.0;
  static const chipTextSize = 12.0;
}
