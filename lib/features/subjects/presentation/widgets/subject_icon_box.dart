import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'home_dimens.dart';
import 'subject_visuals.dart';

class SubjectIconBox extends StatelessWidget {
  const SubjectIconBox({
    super.key,
    required this.subjectId,
    this.size = HomeDimens.iconBox,
    this.radius = HomeDimens.iconBoxRadius,
    this.iconSize = AppSizes.iconMd,
    this.background,
  });

  final String subjectId;
  final double size;
  final double radius;
  final double iconSize;

  /// Defaults to a light tint of the subject colour.
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final visual = SubjectVisual.of(subjectId);
    final color = visual.color(context.colors);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: HomeDimens.iconTintAlpha),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: visual.glyph != null
          ? Text(
              visual.glyph!,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                  fontSize: HomeDimens.glyphFontSize, fontWeight: FontWeight.w700, color: color),
            )
          : Icon(visual.icon, size: iconSize, color: color),
    );
  }
}
