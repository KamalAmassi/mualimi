import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Onboarding step dots, e.g. step 2 of 3.
class StepProgress extends StatelessWidget {
  const StepProgress({super.key, required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      for (var i = 1; i <= total; i++)
        Container(
          width: i == current ? AppSizes.xxl : AppSizes.stepDotSize,
          height: AppSizes.stepDotSize,
          margin: const EdgeInsets.symmetric(horizontal: AppSizes.xs / 2),
          decoration: BoxDecoration(
            color: i <= current ? c.primary : c.outlineStrong,
            borderRadius: BorderRadius.circular(AppSizes.radiusChip),
          ),
        ),
    ]);
  }
}
