import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'profile_dimens.dart';

/// Small tinted button at the end of a setting row («تغيير», «تحقق من تحديث»).
class ProfileActionPill extends StatelessWidget {
  const ProfileActionPill({super.key, required this.label, required this.onPressed});

  final String label;

  /// Null while the action is running: the pill stays visible but ignores taps.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(ProfileDimens.pillRadius);
    return Material(
      color: c.tint,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: ProfileDimens.pillHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProfileDimens.pillPaddingH),
            child: Center(
              widthFactor: 1,
              child: Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: ProfileDimens.pillFontSize,
                      fontWeight: FontWeight.w700,
                      color: c.primary)),
            ),
          ),
        ),
      ),
    );
  }
}