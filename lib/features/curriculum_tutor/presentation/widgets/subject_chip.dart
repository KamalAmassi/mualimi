import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'tutor_sizes.dart';

class SubjectChip extends StatelessWidget {
  const SubjectChip(
      {super.key,
      required this.name,
      required this.supported,
      required this.onTap});

  final String name;
  final bool supported;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = supported ? c.primaryText : c.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TutorSizes.scopeChipRadius),
      child: Container(
        height: TutorSizes.scopeChipHeight,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: supported ? c.tint : c.surfaceVariant,
          borderRadius: BorderRadius.circular(TutorSizes.scopeChipRadius),
          border: supported ? null : Border.all(color: c.outline),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(AppStrings.subjectLabel,
              style: TextStyle(fontSize: TutorSizes.textChip, color: color)),
          const SizedBox(width: AppSizes.xs),
          Text(name,
              style: TextStyle(
                  fontSize: TutorSizes.textChip,
                  fontWeight: FontWeight.w700,
                  color: color)),
          const SizedBox(width: AppSizes.xs),
          Icon(LucideIcons.chevronDown, size: AppSizes.lg, color: color),
        ]),
      ),
    );
  }
}
