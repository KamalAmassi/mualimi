import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../controllers/profile_controller.dart';
import 'profile_sheet_dimens.dart';
import 'profile_sheet_header.dart';
import 'profile_strings.dart';

Future<void> showAboutSheet(ProfileController controller) =>
    showAppBottomSheet<void>(AboutSheet(controller: controller));

/// App name, where the content comes from, and the installed pack.
class AboutSheet extends StatelessWidget {
  const AboutSheet({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final version = controller.current.packVersion;
    final lineStyle =
        TextStyle(fontSize: ProfileSheetDimens.aboutLineFontSize, color: c.textSecondary);
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: ProfileSheetDimens.blockGap,
          children: [
            const ProfileSheetHeader(title: ProfileStrings.about),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: ProfileSheetDimens.aboutLineGap,
              children: [
                Text(AppStrings.appName,
                    style: TextStyle(
                        fontSize: ProfileSheetDimens.aboutNameFontSize,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary)),
                Text(ProfileStrings.aboutSubtitle, style: lineStyle),
                Text(ProfileStrings.noAccount, style: lineStyle),
                if (version != null)
                  Text(
                    '${ProfileStrings.packTitle(controller.gradeOrdinal)}'
                    '${ProfileStrings.separator}${ProfileStrings.version(version)}',
                    style: lineStyle,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
