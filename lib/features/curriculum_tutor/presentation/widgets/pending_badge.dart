import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'tutor_sizes.dart';

/// "Waiting for internet" badge on a queued question, with a delete action.
class PendingBadge extends StatelessWidget {
  const PendingBadge({super.key, required this.onDelete});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.sm),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md, vertical: AppSizes.xs + 2),
          decoration: BoxDecoration(
            color: c.warningContainer,
            borderRadius: BorderRadius.circular(AppSizes.radiusChip),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(LucideIcons.clock, size: AppSizes.md + 2, color: c.warning),
            const SizedBox(width: AppSizes.xs + 2),
            Text(AppStrings.pendingBadge,
                style: TextStyle(
                    fontSize: TutorSizes.textSmall,
                    fontWeight: FontWeight.w600,
                    color: c.onWarningContainer)),
          ]),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onDelete,
          icon: Icon(LucideIcons.trash2,
              size: AppSizes.lg, color: c.textSecondary),
          label: Text(AppStrings.deletePendingQuestion,
              style: TextStyle(
                  fontSize: TutorSizes.textSmall, color: c.textSecondary)),
        ),
      ]),
    );
  }
}
