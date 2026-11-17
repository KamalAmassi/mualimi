import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'profile_dimens.dart';

class StorageLegendItem extends StatelessWidget {
  const StorageLegendItem({super.key, required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: ProfileDimens.legendDot,
        height: ProfileDimens.legendDot,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(ProfileDimens.legendDotRadius),
        ),
      ),
      const SizedBox(width: ProfileDimens.legendGap),
      Expanded(
        child: Text(label,
            style: TextStyle(
                fontSize: ProfileDimens.legendFontSize, color: context.colors.textPrimary)),
      ),
    ]);
  }
}