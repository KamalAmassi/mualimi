import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'profile_sheet_dimens.dart';

/// Full-width sheet action; a null [onPressed] shows the muted disabled look.
class ProfileSheetButton extends StatelessWidget {
  const ProfileSheetButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(ProfileSheetDimens.buttonHeight),
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
        disabledBackgroundColor: c.surfaceVariant,
        disabledForegroundColor: c.textSecondary,
        textStyle: const TextStyle(
            fontSize: ProfileSheetDimens.buttonFontSize, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ProfileSheetDimens.buttonRadius)),
      ),
      child: Text(label, textAlign: TextAlign.center),
    );
  }
}
