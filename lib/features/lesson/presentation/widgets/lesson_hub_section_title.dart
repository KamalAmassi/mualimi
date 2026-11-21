import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'lesson_hub_dimens.dart';

/// Section heading with an optional trailing count.
class LessonHubSectionTitle extends StatelessWidget {
  const LessonHubSectionTitle({super.key, required this.title, this.count});

  final String title;
  final String? count;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
        child: Text(
          title,
          style: TextStyle(
            fontSize: LessonHubDimens.sectionTitleSize,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
      ),
      if (count != null)
        Text(
          count!,
          style: TextStyle(fontSize: LessonHubDimens.sectionCountSize, color: c.textSecondary),
        ),
    ]);
  }
}
