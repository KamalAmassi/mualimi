import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'lesson_chip.dart';
import 'pick_lesson_chip.dart';
import 'subject_chip.dart';
import 'tutor_sizes.dart';

/// Subject chip and optional lesson chip under the header.
class ScopeBar extends StatelessWidget {
  const ScopeBar({
    super.key,
    required this.subjectName,
    required this.lessonTitle,
    required this.supported,
    required this.onPick,
    required this.onClearLesson,
  });

  final String subjectName;
  final String? lessonTitle;
  final bool supported;
  final VoidCallback onPick;
  final VoidCallback onClearLesson;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding:
          const EdgeInsets.fromLTRB(AppSizes.lg, 0, AppSizes.lg, AppSizes.md),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(bottom: BorderSide(color: c.outline)),
      ),
      child: Row(children: [
        SubjectChip(name: subjectName, supported: supported, onTap: onPick),
        const SizedBox(width: AppSizes.sm),
        if (!supported)
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md, vertical: AppSizes.sm),
            decoration: BoxDecoration(
              color: c.infoContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusChip),
            ),
            child: Text(AppStrings.comingSoon,
                style: TextStyle(
                    fontSize: TutorSizes.textChip,
                    fontWeight: FontWeight.w700,
                    color: c.onInfoContainer)),
          )
        else
          Flexible(
            child: lessonTitle == null
                ? PickLessonChip(onTap: onPick)
                : LessonChip(
                    title: lessonTitle!, onTap: onPick, onClear: onClearLesson),
          ),
      ]),
    );
  }
}
