import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/lesson_section.dart';
import 'viewer_dimens.dart';

/// One lesson section: its title and body, rendered as plain text.
class ViewerSectionArticle extends StatelessWidget {
  const ViewerSectionArticle({super.key, required this.section});

  final LessonSection section;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ColoredBox(
      color: c.surface,
      child: SingleChildScrollView(
        padding: ViewerDimens.articlePadding,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            section.title,
            style: TextStyle(
              fontSize: ViewerDimens.headingSize,
              fontWeight: FontWeight.w700,
              color: c.primary,
            ),
          ),
          const SizedBox(height: ViewerDimens.articleGap),
          Text(
            section.body,
            style: TextStyle(
              fontSize: ViewerDimens.bodySize,
              height: ViewerDimens.bodyLineHeight,
              color: c.textPrimary,
            ),
          ),
        ]),
      ),
    );
  }
}
