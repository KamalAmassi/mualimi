import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_strings.dart';
import 'welcome_dimens.dart';

/// "Next" with the forward chevron after the label (left side in RTL).
class WelcomeNextButton extends StatelessWidget {
  const WelcomeNextButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      iconAlignment: IconAlignment.end,
      icon: const Icon(LucideIcons.chevronLeft, size: WelcomeDimens.buttonIcon),
      label: const Text(
        AppStrings.next,
        style: TextStyle(fontSize: WelcomeDimens.buttonFontSize, fontWeight: FontWeight.w600),
      ),
    );
  }
}
