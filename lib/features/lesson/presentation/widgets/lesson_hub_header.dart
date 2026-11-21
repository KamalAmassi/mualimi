import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import 'lesson_hub_dimens.dart';
import 'lesson_hub_strings.dart';

/// Back button, lesson title and its subject · unit · pages line. The design's
/// bookmark slot stays empty so the title keeps its width.
class LessonHubHeader extends StatelessWidget {
  const LessonHubHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(bottom: BorderSide(color: c.outline, width: LessonHubDimens.headerBorder)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: LessonHubDimens.headerPadding,
          child: Row(children: [
            SizedBox.square(
              dimension: LessonHubDimens.headerTapTarget,
              child: IconButton(
                onPressed: onBack,
                tooltip: LessonHubStrings.back,
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(LessonHubDimens.headerTapRadius),
                  ),
                ),
                icon: Icon(LucideIcons.chevronRight,
                    size: LessonHubDimens.headerIcon, color: c.textPrimary),
              ),
            ),
            const SizedBox(width: LessonHubDimens.headerGap),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  title,
                  maxLines: LessonHubDimens.titleMaxLines,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: LessonHubDimens.titleSize,
                    fontWeight: FontWeight.w700,
                    height: LessonHubDimens.titleLineHeight,
                    color: c.textPrimary,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: LessonHubDimens.subtitleGap),
                  Text(
                    subtitle,
                    maxLines: LessonHubDimens.subtitleMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: LessonHubDimens.subtitleSize, color: c.textSecondary),
                  ),
                ],
              ]),
            ),
            const SizedBox(width: LessonHubDimens.headerGap + LessonHubDimens.headerTapTarget),
          ]),
        ),
      ),
    );
  }
}
