import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'subject_dimens.dart';

/// Position of a lesson in its unit; highlighted for the last opened lesson.
class SubjectLessonNumber extends StatelessWidget {
  const SubjectLessonNumber({super.key, required this.number, required this.highlighted});

  final int number;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: SubjectDimens.numberBox,
      height: SubjectDimens.numberBox,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: highlighted ? c.primary : c.background,
        borderRadius: BorderRadius.circular(SubjectDimens.numberRadius),
      ),
      child: Text(
        '$number',
        textScaler: TextScaler.noScaling,
        style: TextStyle(
          fontSize: SubjectDimens.numberFontSize,
          fontWeight: FontWeight.w700,
          color: highlighted ? c.onPrimary : c.textSecondary,
        ),
      ),
    );
  }
}
