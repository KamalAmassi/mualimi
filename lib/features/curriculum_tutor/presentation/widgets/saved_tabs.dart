import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'tutor_sizes.dart';

/// Two-way switch between saved answers and question history.
class SavedTabs extends StatelessWidget {
  const SavedTabs(
      {super.key, required this.historySelected, required this.onSelect});

  final bool historySelected;
  final ValueChanged<bool> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSizes.xs),
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.md),
      ),
      child: Row(children: [
        Expanded(
          child: _Tab(
            label: AppStrings.savedTab,
            selected: !historySelected,
            onTap: () => onSelect(false),
          ),
        ),
        Expanded(
          child: _Tab(
            label: AppStrings.questionHistory,
            selected: historySelected,
            onTap: () => onSelect(true),
          ),
        ),
      ]),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(TutorSizes.tabRadius);
    return Material(
      color: selected ? c.surface : Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          height: TutorSizes.tabHeight,
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? c.textPrimary : c.textSecondary,
              )),
        ),
      ),
    );
  }
}
