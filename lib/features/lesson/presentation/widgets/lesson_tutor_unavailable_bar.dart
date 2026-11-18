import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import 'lesson_hub_dimens.dart';
import 'lesson_hub_strings.dart';

/// Shown in place of the ask-tutor bar when the lesson or its subject has the
/// tutor turned off.
class LessonTutorUnavailableBar extends StatelessWidget {
  const LessonTutorUnavailableBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minHeight: LessonHubDimens.barMinHeight),
      padding: LessonHubDimens.barPadding,
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        border: Border.all(color: c.outline, width: LessonHubDimens.barBorder),
        borderRadius: BorderRadius.circular(LessonHubDimens.barRadius),
      ),
      child: Row(children: [
        Container(
          width: LessonHubDimens.barTileSize,
          height: LessonHubDimens.barTileSize,
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(LessonHubDimens.barTileRadius),
          ),
          child: Icon(LucideIcons.sparkles,
              size: LessonHubDimens.barTileIcon, color: c.textSecondary),
        ),
        const SizedBox(width: LessonHubDimens.barGap),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              LessonHubStrings.tutorUnavailableTitle,
              style: TextStyle(
                fontSize: LessonHubDimens.barTitleSize,
                fontWeight: FontWeight.w700,
                color: c.textSecondary,
              ),
            ),
            Text(
              LessonHubStrings.tutorUnavailableBody,
              style: TextStyle(fontSize: LessonHubDimens.barSubtitleSize, color: c.textSecondary),
            ),
          ]),
        ),
        const SizedBox(width: LessonHubDimens.barGap),
        Container(
          padding: LessonHubDimens.chipPadding,
          decoration: BoxDecoration(
            color: c.infoContainer,
            borderRadius: BorderRadius.circular(LessonHubDimens.chipRadius),
          ),
          child: Text(
            LessonHubStrings.comingSoon,
            style: TextStyle(
              fontSize: LessonHubDimens.chipTextSize,
              fontWeight: FontWeight.w600,
              color: c.onInfoContainer,
            ),
          ),
        ),
      ]),
    );
  }
}
