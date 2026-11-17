import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'home_dimens.dart';

/// Translucent pill on the hero: optional icon + label.
class HomeHeroChip extends StatelessWidget {
  const HomeHeroChip({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: HomeDimens.chipPaddingH, vertical: HomeDimens.chipPaddingV),
      decoration: ShapeDecoration(color: c.heroChip, shape: const StadiumBorder()),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[
          Icon(icon, size: HomeDimens.chipIcon, color: c.onHero),
          const SizedBox(width: HomeDimens.chipGapInner),
        ],
        Flexible(
          child: Text(
            label,
            style: TextStyle(
                fontSize: HomeDimens.chipFontSize, fontWeight: FontWeight.w600, color: c.onHero),
          ),
        ),
      ]),
    );
  }
}
