import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import 'lesson_hub_dimens.dart';
import 'lesson_hub_strings.dart';

/// «مش فاهم؟ اسأل المعلّم»: opens the tutor on this lesson.
class LessonAskTutorBar extends StatelessWidget {
  const LessonAskTutorBar({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(LessonHubDimens.barRadius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: c.shadowStrong,
            offset: LessonHubDimens.barShadowOffset,
            blurRadius: LessonHubDimens.barShadowBlur,
          ),
        ],
      ),
      child: Material(
        color: c.primary,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: LessonHubDimens.barMinHeight),
            child: Padding(
              padding: LessonHubDimens.barPadding,
              child: Row(children: [
                Container(
                  width: LessonHubDimens.barTileSize,
                  height: LessonHubDimens.barTileSize,
                  decoration: BoxDecoration(
                    color: c.accent,
                    borderRadius: BorderRadius.circular(LessonHubDimens.barTileRadius),
                  ),
                  child: Icon(LucideIcons.sparkles,
                      size: LessonHubDimens.barTileIcon, color: c.onAccent),
                ),
                const SizedBox(width: LessonHubDimens.barGap),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      LessonHubStrings.askTutorTitle,
                      style: TextStyle(
                        fontSize: LessonHubDimens.barTitleSize,
                        fontWeight: FontWeight.w700,
                        color: c.onPrimary,
                      ),
                    ),
                    Text(
                      LessonHubStrings.askTutorSubtitle,
                      style: TextStyle(
                          fontSize: LessonHubDimens.barSubtitleSize, color: c.onPrimaryMuted),
                    ),
                  ]),
                ),
                const SizedBox(width: LessonHubDimens.barGap),
                Icon(LucideIcons.chevronLeft, size: LessonHubDimens.barChevron, color: c.onPrimary),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
