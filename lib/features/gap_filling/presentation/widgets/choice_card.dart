import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'gap_filling_dimens.dart';

enum ChoiceState { idle, selected, correct, gentle }

/// One large answer card. [ChoiceState.gentle] marks a missed choice without
/// using the error color.
class ChoiceCard extends StatelessWidget {
  const ChoiceCard({super.key, required this.label, required this.state, this.onTap});

  final String label;
  final ChoiceState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (background, border, icon, iconColor) = switch (state) {
      ChoiceState.idle => (c.surface, c.outline, LucideIcons.circle, c.outlineStrong),
      ChoiceState.selected => (c.tint, c.primary, LucideIcons.circleCheck, c.primary),
      ChoiceState.correct => (c.successContainer, c.success, LucideIcons.circleCheck, c.success),
      ChoiceState.gentle => (c.warningContainer, c.warningOutline, LucideIcons.circle, c.warning),
    };
    final radius = BorderRadius.circular(AppSizes.radiusCard);
    return Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: border, width: GapFillingDimens.choiceBorderWidth),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: GapFillingDimens.choiceMinHeight),
          child: Padding(
            padding: GapFillingDimens.choicePadding,
            child: Row(children: [
              Icon(icon, size: GapFillingDimens.choiceMarkSize, color: iconColor),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: GapFillingDimens.bodySize,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
