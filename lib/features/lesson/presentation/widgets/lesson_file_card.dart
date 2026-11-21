import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import 'lesson_hub_dimens.dart';

/// One row of the lesson files: coloured icon tile, title and meta line.
class LessonFileCard extends StatelessWidget {
  const LessonFileCard({
    super.key,
    required this.icon,
    required this.tileColor,
    required this.iconColor,
    required this.title,
    required this.meta,
    required this.onTap,
    this.showChevron = false,
  });

  final IconData icon;
  final Color tileColor;
  final Color iconColor;
  final String title;
  final String meta;
  final VoidCallback onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(LessonHubDimens.fileCardRadius),
      side: BorderSide(color: c.outline, width: LessonHubDimens.fileCardBorder),
    );
    return Material(
      color: c.surface,
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Padding(
          padding: LessonHubDimens.fileCardPadding,
          child: Row(children: [
            Container(
              width: LessonHubDimens.fileTileSize,
              height: LessonHubDimens.fileTileSize,
              decoration: BoxDecoration(
                color: tileColor,
                borderRadius: BorderRadius.circular(LessonHubDimens.fileTileRadius),
              ),
              child: Icon(icon, size: LessonHubDimens.fileTileIcon, color: iconColor),
            ),
            const SizedBox(width: LessonHubDimens.fileCardGap),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: LessonHubDimens.fileTitleSize,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
                Text(
                  meta,
                  style: TextStyle(fontSize: LessonHubDimens.fileMetaSize, color: c.textSecondary),
                ),
              ]),
            ),
            if (showChevron) ...[
              const SizedBox(width: LessonHubDimens.fileCardGap),
              Icon(LucideIcons.chevronLeft,
                  size: LessonHubDimens.fileChevron, color: c.textSecondary),
            ],
          ]),
        ),
      ),
    );
  }
}
