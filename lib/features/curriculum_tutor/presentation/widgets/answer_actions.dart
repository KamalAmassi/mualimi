import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/follow_up.dart';
import 'tutor_sizes.dart';

/// Follow-up chips, then save and report under an answer.
class AnswerActions extends StatelessWidget {
  const AnswerActions({
    super.key,
    required this.showFollowUps,
    required this.saved,
    required this.onFollowUp,
    required this.onSave,
    required this.onReport,
  });

  final bool showFollowUps;
  final bool saved;
  final ValueChanged<FollowUp> onFollowUp;
  final VoidCallback onSave;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (showFollowUps) ...[
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final f in FollowUp.values)
            OutlinedButton(
              onPressed: () => onFollowUp(f),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, TutorSizes.chipHeight),
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                shape: const StadiumBorder(),
                side: BorderSide(color: c.outlineStrong),
                foregroundColor: c.primaryText,
              ),
              child: Text(f.label,
                  style: const TextStyle(
                      fontSize: TutorSizes.textChip,
                      fontWeight: FontWeight.w600)),
            ),
        ]),
        const SizedBox(height: AppSizes.md),
      ],
      Container(
        padding: const EdgeInsets.only(top: AppSizes.sm),
        decoration:
            BoxDecoration(border: Border(top: BorderSide(color: c.outline))),
        child: Row(children: [
          _Action(
            icon: saved ? LucideIcons.bookmarkCheck : LucideIcons.bookmark,
            label: saved ? AppStrings.answerSaved : AppStrings.save,
            color: c.textPrimary,
            onTap: saved ? null : onSave,
          ),
          const Spacer(),
          _Action(
            icon: LucideIcons.flag,
            label: AppStrings.reportAnswer,
            color: c.textSecondary,
            onTap: onReport,
          ),
        ]),
      ),
    ]);
  }
}

class _Action extends StatelessWidget {
  const _Action(
      {required this.icon,
      required this.label,
      required this.color,
      this.onTap});

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: TutorSizes.actionHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: AppSizes.xl - 2, color: color),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(fontSize: TutorSizes.textChip, color: color)),
          ]),
        ),
      ),
    );
  }
}
