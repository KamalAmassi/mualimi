import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/lesson_summary.dart';
import 'subject_dimens.dart';
import 'subject_lesson_number.dart';
import 'subject_strings.dart';

class SubjectLessonRow extends StatelessWidget {
  const SubjectLessonRow({
    super.key,
    required this.lesson,
    required this.number,
    required this.lastOpened,
    required this.onTap,
  });

  final LessonSummary lesson;
  final int number;
  final bool lastOpened;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(SubjectDimens.lessonRadius);
    final subtitle = SubjectStrings.lessonSubtitle(
        from: lesson.bookPagesFrom, to: lesson.bookPagesTo, lastOpened: lastOpened);
    return Material(
      color: lastOpened ? c.tint : c.surface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(SubjectDimens.lessonPadding),
          child: Row(children: [
            SubjectLessonNumber(number: number, highlighted: lastOpened),
            const SizedBox(width: SubjectDimens.lessonGap),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(lesson.title,
                    style: TextStyle(
                        fontSize: SubjectDimens.lessonTitleFontSize,
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary)),
                if (subtitle != null)
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: SubjectDimens.lessonSubtitleFontSize,
                          color: c.textSecondary)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
