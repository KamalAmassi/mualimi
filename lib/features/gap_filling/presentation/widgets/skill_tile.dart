import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/skill.dart';
import 'gap_filling_dimens.dart';
import 'gap_filling_strings.dart';

/// A skill with its original grade. With [actionLabel] it shows a button,
/// otherwise the whole tile is the tap target.
class SkillTile extends StatelessWidget {
  const SkillTile({super.key, required this.skill, required this.onTap, this.actionLabel});

  final Skill skill;
  final VoidCallback onTap;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      onTap: actionLabel == null ? onTap : null,
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              skill.title,
              style: TextStyle(
                fontSize: GapFillingDimens.bodySize,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              GapFillingStrings.fromGrade(skill.grade),
              style: TextStyle(color: c.textSecondary),
            ),
          ]),
        ),
        const SizedBox(width: AppSizes.md),
        if (actionLabel == null)
          Icon(LucideIcons.chevronLeft, size: AppSizes.iconMd, color: c.textSecondary)
        else
          FilledButton.tonal(
            style: FilledButton.styleFrom(
                minimumSize: const Size(0, AppSizes.buttonHeight)),
            onPressed: onTap,
            child: Text(actionLabel!),
          ),
      ]),
    );
  }
}
