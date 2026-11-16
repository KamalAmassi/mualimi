import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'tutor_sizes.dart';

class StopGenerationButton extends StatelessWidget {
  const StopGenerationButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(LucideIcons.square,
            size: AppSizes.md + 2, color: c.textPrimary),
        label: const Text(AppStrings.stopGeneration,
            style: TextStyle(fontSize: TutorSizes.textChip)),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, TutorSizes.stopButtonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          shape: const StadiumBorder(),
          side: BorderSide(color: c.outline),
          backgroundColor: c.surface,
          foregroundColor: c.textPrimary,
        ),
      ),
    );
  }
}
