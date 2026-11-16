import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'welcome_dimens.dart';

/// Onboarding progress bars followed by a "step n of m" label.
class OnboardingStepIndicator extends StatelessWidget {
  const OnboardingStepIndicator({
    super.key,
    required this.current,
    required this.total,
    required this.label,
  });

  final int current;
  final int total;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      spacing: WelcomeDimens.stepGap,
      children: [
        for (var step = 1; step <= total; step++)
          Container(
            width: step == current ? WelcomeDimens.stepActiveWidth : WelcomeDimens.stepWidth,
            height: WelcomeDimens.stepHeight,
            decoration: BoxDecoration(
              color: step <= current ? colors.primary : colors.outline,
              borderRadius: BorderRadius.circular(WelcomeDimens.stepRadius),
            ),
          ),
        Flexible(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: WelcomeDimens.stepGap),
            child: Text(
              label,
              style: TextStyle(color: colors.textSecondary, fontSize: WelcomeDimens.stepFontSize),
            ),
          ),
        ),
      ],
    );
  }
}
