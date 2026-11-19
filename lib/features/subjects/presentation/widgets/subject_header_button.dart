import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'subject_dimens.dart';

/// 44×44 icon button on the purple header.
class SubjectHeaderButton extends StatelessWidget {
  const SubjectHeaderButton({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.tooltip,
    required this.onPressed,
    this.filled = false,
  });

  final IconData icon;
  final double iconSize;
  final String tooltip;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox.square(
      dimension: SubjectDimens.headerButton,
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: filled ? c.heroChip : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SubjectDimens.headerButtonRadius),
          ),
        ),
        icon: Icon(icon, size: iconSize, color: c.onHero),
      ),
    );
  }
}
