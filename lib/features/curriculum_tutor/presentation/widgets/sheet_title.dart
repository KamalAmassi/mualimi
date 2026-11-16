import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

/// Title row of a bottom sheet with a close button.
class SheetTitle extends StatelessWidget {
  const SheetTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(children: [
      Expanded(
        child: Text(title,
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: c.textPrimary)),
      ),
      IconButton(
        tooltip: AppStrings.close,
        onPressed: Get.back<void>,
        style: IconButton.styleFrom(backgroundColor: c.surfaceVariant),
        icon: Icon(LucideIcons.x,
            size: AppSizes.iconMd - 4, color: c.textPrimary),
      ),
    ]);
  }
}
