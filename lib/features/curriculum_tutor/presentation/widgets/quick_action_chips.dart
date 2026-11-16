import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/quick_action.dart';
import 'tutor_sizes.dart';

/// "Explain the lesson", "summarize", "key terms". Needs a selected lesson.
class QuickActionChips extends StatelessWidget {
  const QuickActionChips(
      {super.key, required this.enabled, required this.onSelected});

  final bool enabled;
  final ValueChanged<QuickAction> onSelected;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      height: TutorSizes.chipHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: QuickAction.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
        itemBuilder: (context, i) {
          final action = QuickAction.values[i];
          return OutlinedButton(
            onPressed: enabled ? () => onSelected(action) : null,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, TutorSizes.chipHeight),
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              shape: const StadiumBorder(),
              side: BorderSide(color: c.outline),
              backgroundColor: c.surface,
              foregroundColor: i == 0 ? c.primary : c.textPrimary,
            ),
            child: Text(action.label,
                style: TextStyle(
                    fontSize: TutorSizes.textChip,
                    fontWeight: i == 0 ? FontWeight.w600 : FontWeight.w400)),
          );
        },
      ),
    );
  }
}
