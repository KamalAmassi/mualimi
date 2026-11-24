import 'package:flutter/widgets.dart';

import 'viewer_dimens.dart';

/// Section body measurements from design/screens/light/Viewer.html and
/// LessonMath.html; body text, `##` and block spacing reuse [ViewerDimens].
/// Font sizes are multiplied by the reading font scale.
abstract final class SectionBodyDimens {
  static const heading3Size = 17.0;
  static const heading2TopGap = 6.0;

  static const bulletIndent = 20.0;
  static const bulletGlyph = '•';

  static const calloutPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 12);
  static const calloutRadius = 14.0;
  static const calloutGap = 10.0;
  static const calloutIcon = 22.0;
  static const calloutTextSize = 14.5;
  static const calloutLineHeight = 1.8;

  static const displayMathPadding = EdgeInsets.symmetric(horizontal: 18, vertical: 10);
  static const displayMathRadius = 12.0;
  static const displayMathSize = 24.0;

  static const tableRadius = 12.0;
  static const tableBorderWidth = 1.0;
  static const tableCellPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const tableTextSize = 14.5;
  static const tableLineHeight = 1.6;
  static const tableMaxColumnWidth = 220.0;

  static const imageRadius = 12.0;
  static const imageCaptionGap = 6.0;
  static const captionSize = 13.0;
}
