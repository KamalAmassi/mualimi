import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'tutor_sizes.dart';

class LessonChip extends StatelessWidget {
  const LessonChip(
      {super.key,
      required this.title,
      required this.onTap,
      required this.onClear});

  final String title;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TutorSizes.scopeChipRadius),
      child: Container(
        height: TutorSizes.scopeChipHeight,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(TutorSizes.scopeChipRadius),
          border: Border.all(color: c.outline),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(AppStrings.lessonLabel,
              style: TextStyle(
                  fontSize: TutorSizes.textChip, color: c.textSecondary)),
          const SizedBox(width: AppSizes.xs),
          Flexible(
            child: Text(title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: TutorSizes.textChip,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary)),
          ),
          const SizedBox(width: AppSizes.xs),
          GestureDetector(
            onTap: onClear,
            child:
                Icon(LucideIcons.x, size: AppSizes.lg, color: c.textSecondary),
          ),
        ]),
      ),
    );
  }
}
