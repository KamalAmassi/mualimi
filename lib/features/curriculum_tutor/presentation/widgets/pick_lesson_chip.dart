import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import 'dashed_border_painter.dart';
import 'tutor_sizes.dart';

class PickLessonChip extends StatelessWidget {
  const PickLessonChip({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TutorSizes.scopeChipRadius),
      child: CustomPaint(
        painter: DashedBorderPainter(
            color: c.outlineStrong, radius: TutorSizes.scopeChipRadius),
        child: Container(
          height: TutorSizes.scopeChipHeight,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: Text(AppStrings.pickLessonOptional,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: TutorSizes.textChip, color: c.textSecondary)),
        ),
      ),
    );
  }
}
