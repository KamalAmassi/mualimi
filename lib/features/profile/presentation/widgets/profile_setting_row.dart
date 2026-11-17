import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import 'profile_dimens.dart';

/// Icon box, title over subtitle, and either [action] or a chevron at the end.
class ProfileSettingRow extends StatelessWidget {
  const ProfileSettingRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: ProfileDimens.rowMinHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: ProfileDimens.rowPaddingH, vertical: ProfileDimens.rowPaddingV),
          child: Row(children: [
            Container(
              width: ProfileDimens.rowIconBox,
              height: ProfileDimens.rowIconBox,
              decoration: BoxDecoration(
                color: c.background,
                borderRadius: BorderRadius.circular(ProfileDimens.rowIconRadius),
              ),
              child: Icon(icon, size: ProfileDimens.rowIcon, color: c.primary),
            ),
            const SizedBox(width: ProfileDimens.rowPaddingV),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title,
                    style: TextStyle(
                        fontSize: ProfileDimens.rowTitleFontSize,
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary)),
                if (subtitle.isNotEmpty)
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: ProfileDimens.rowSubtitleFontSize, color: c.textSecondary)),
              ]),
            ),
            const SizedBox(width: ProfileDimens.rowPaddingV),
            if (action != null)
              Flexible(child: action!)
            else
              Icon(LucideIcons.chevronLeft,
                  size: ProfileDimens.rowChevron, color: c.textSecondary),
          ]),
        ),
      ),
    );
  }
}