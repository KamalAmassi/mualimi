import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import 'profile_sheet_dimens.dart';

/// Sheet title with the round close button at the end.
class ProfileSheetHeader extends StatelessWidget {
  const ProfileSheetHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(children: [
      Expanded(
        child: Text(title,
            style: TextStyle(
                fontSize: ProfileSheetDimens.titleFontSize,
                fontWeight: FontWeight.w700,
                color: c.textPrimary)),
      ),
      const SizedBox(width: ProfileSheetDimens.titleGap),
      Semantics(
        container: true,
        button: true,
        label: AppStrings.close,
        excludeSemantics: true,
        child: Material(
          color: c.surfaceVariant,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Get.back<void>(),
            child: SizedBox.square(
              dimension: ProfileSheetDimens.closeSize,
              child: Icon(LucideIcons.x, size: ProfileSheetDimens.closeIcon, color: c.textPrimary),
            ),
          ),
        ),
      ),
    ]);
  }
}
