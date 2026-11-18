import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'grade_dimens.dart';

/// Download button with the icon after the label (left side in RTL);
/// disabled while [onPressed] is null.
class GradeDownloadButton extends StatelessWidget {
  const GradeDownloadButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      iconAlignment: IconAlignment.end,
      icon: const Icon(LucideIcons.download, size: GradeDimens.buttonIcon),
      label: Text(
        label,
        style: const TextStyle(fontSize: GradeDimens.buttonFontSize, fontWeight: FontWeight.w600),
      ),
    );
  }
}
