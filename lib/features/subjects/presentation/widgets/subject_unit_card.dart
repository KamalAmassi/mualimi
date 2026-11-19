import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/lesson_summary.dart';
import '../../domain/entities/subject_unit.dart';
import 'subject_dimens.dart';
import 'subject_lesson_row.dart';
import 'subject_strings.dart';

/// A collapsible unit with its lessons.
class SubjectUnitCard extends StatelessWidget {
  const SubjectUnitCard({
    super.key,
    required this.unit,
    required this.expanded,
    required this.lastOpenedLessonId,
    required this.onToggle,
    required this.onOpenLesson,
  });

  final SubjectUnit unit;
  final bool expanded;
  final String? lastOpenedLessonId;
  final VoidCallback onToggle;
  final ValueChanged<LessonSummary> onOpenLesson;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(AppSizes.radiusCard);
    return Material(
      color: c.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: radius, side: BorderSide(color: c.outline)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Semantics(
          button: true,
          expanded: expanded,
          child: InkWell(
            onTap: onToggle,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: SubjectDimens.unitMinHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: SubjectDimens.unitPaddingH, vertical: SubjectDimens.unitPaddingV),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(unit.title,
                          style: TextStyle(
                              fontSize: SubjectDimens.unitTitleFontSize,
                              fontWeight: FontWeight.w700,
                              color: c.textPrimary)),
                      Text(SubjectStrings.lessonsCount(unit.lessons.length),
                          style: TextStyle(
                              fontSize: SubjectDimens.unitCountFontSize,
                              color: c.textSecondary)),
                    ]),
                  ),
                  const SizedBox(width: SubjectDimens.unitGap),
                  Icon(expanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                      size: SubjectDimens.chevron, color: c.textSecondary),
                ]),
              ),
            ),
          ),
        ),
        if (expanded && unit.lessons.isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(SubjectDimens.lessonsPadding, 0,
                SubjectDimens.lessonsPadding, SubjectDimens.lessonsPadding),
            child: Column(spacing: SubjectDimens.lessonsGap, children: [
              for (final (index, lesson) in unit.lessons.indexed)
                SubjectLessonRow(
                  lesson: lesson,
                  number: index + 1,
                  lastOpened: lesson.id == lastOpenedLessonId,
                  onTap: () => onOpenLesson(lesson),
                ),
            ]),
          ),
      ]),
    );
  }
}
