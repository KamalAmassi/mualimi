import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/continue_lesson.dart';
import 'home_dimens.dart';
import 'home_strings.dart';
import 'subject_icon_box.dart';

/// "Continue where you left off": the most recently opened lesson.
class ContinueLessonCard extends StatelessWidget {
  const ContinueLessonCard({super.key, required this.lesson, required this.onTap});

  final ContinueLesson lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(HomeDimens.continueRadius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: c.shadowSoft,
            blurRadius: HomeDimens.shadowBlur,
            offset: const Offset(0, HomeDimens.shadowOffsetY),
          ),
        ],
      ),
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(borderRadius: radius, side: BorderSide(color: c.outline)),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(HomeDimens.continuePadding),
            child: Row(children: [
              SubjectIconBox(
                subjectId: lesson.subjectId,
                size: HomeDimens.continueIconBox,
                radius: HomeDimens.continueIconRadius,
                iconSize: HomeDimens.continueIcon,
              ),
              const SizedBox(width: HomeDimens.continueGap),
              Expanded(child: _Titles(lesson: lesson)),
              const SizedBox(width: HomeDimens.continueGap),
              Container(
                width: HomeDimens.playSize,
                height: HomeDimens.playSize,
                decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
                child: Icon(LucideIcons.play, size: HomeDimens.playIcon, color: c.onPrimary),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Titles extends StatelessWidget {
  const _Titles({required this.lesson});

  final ContinueLesson lesson;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(HomeStrings.continueLabel,
          style: TextStyle(
              fontSize: HomeDimens.badgeFontSize, fontWeight: FontWeight.w600, color: c.primaryText)),
      Text(lesson.lessonTitle,
          style: TextStyle(
              fontSize: HomeDimens.continueTitleFontSize,
              fontWeight: FontWeight.w700,
              color: c.textPrimary)),
      Text('${lesson.subjectName}${HomeStrings.subtitleSeparator}${lesson.unitTitle}',
          style: TextStyle(fontSize: HomeDimens.continueSubtitleFontSize, color: c.textSecondary)),
    ]);
  }
}
