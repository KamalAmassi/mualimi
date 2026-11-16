import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'tutor_sizes.dart';

class HistorySearchField extends StatelessWidget {
  const HistorySearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: TutorSizes.searchHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: BoxDecoration(
        color: c.background,
        border: Border.all(color: c.outline),
        borderRadius: BorderRadius.circular(TutorSizes.exampleRadius),
      ),
      child: Row(children: [
        Icon(LucideIcons.search, size: AppSizes.xl - 2, color: c.textSecondary),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: TextField(
            onChanged: onChanged,
            style: TextStyle(fontSize: 14, color: c.textPrimary),
            decoration: const InputDecoration(
              hintText: AppStrings.searchHistoryHint,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              isCollapsed: true,
            ),
          ),
        ),
      ]),
    );
  }
}
