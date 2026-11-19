import 'package:flutter/widgets.dart';

import '../../../../core/constants/app_sizes.dart';

abstract final class GapFillingDimens {
  static const pagePadding = EdgeInsets.all(AppSizes.pagePadding);
  static const choicePadding = EdgeInsets.symmetric(
      horizontal: AppSizes.lg, vertical: AppSizes.md);
  static const choiceMinHeight = 64.0;
  static const choiceBorderWidth = 1.5;
  static const choiceMarkSize = 24.0;
  static const heroIconSize = 72.0;
  static const titleSize = 24.0;
  static const bodySize = 16.0;
  static const questionSize = 20.0;
  static const miniLessonHeadingSize = 18.0;
  static const miniLessonLineHeight = 1.7;
  static const bulletDotSize = 6.0;
  static const bulletDotTop = 10.0;
}
