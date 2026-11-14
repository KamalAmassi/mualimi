import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/saved_answer.dart';
import '../formatting/day_label.dart';
import 'tutor_sizes.dart';

class SavedAnswerCard extends StatelessWidget {
  const SavedAnswerCard({
    super.key,
    required this.answer,
    required this.expanded,
    required this.onTap,
    required this.onDelete,
  });

  final SavedAnswer answer;
  final bool expanded;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final source = answer.source;
    final created = answer.createdAt;
    final radius = BorderRadius.circular(AppSizes.radiusCard);
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
          borderRadius: radius, side: BorderSide(color: c.outline)),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Container(
                width: TutorSizes.subjectDot,
                height: TutorSizes.subjectDot,
                decoration: BoxDecoration(
                    color: c.subjectScience, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  source == null
                      ? ''
                      : '${source.subjectName} · ${AppStrings.pagesPrefix} ${source.printedPage}',
                  style: TextStyle(
                      fontSize: TutorSizes.textSmall, color: c.textSecondary),
                ),
              ),
              if (created != null)
                Text(DayLabel.of(created, now: DateTime.now()),
                    style: TextStyle(
                        fontSize: TutorSizes.textSmall,
                        color: c.textSecondary)),
              InkWell(
                onTap: onDelete,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: AppSizes.sm, left: AppSizes.sm),
                  child: Icon(LucideIcons.trash2,
                      size: AppSizes.lg, color: c.textSecondary),
                ),
              ),
            ]),
            const SizedBox(height: AppSizes.sm),
            Text(answer.question,
                style: TextStyle(
                    fontSize: TutorSizes.textBody,
                    fontWeight: FontWeight.w700,
                    height: 1.6,
                    color: c.textPrimary)),
            const SizedBox(height: AppSizes.sm),
            Text(answer.answer,
                maxLines: expanded ? null : 3,
                overflow:
                    expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: 13.5, height: 1.7, color: c.textBody)),
          ]),
        ),
      ),
    );
  }
}
