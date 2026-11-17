import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import 'profile_dimens.dart';
import 'profile_strings.dart';

/// Avatar letter, name, grade line and the edit-name button.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.initial,
    required this.name,
    required this.subtitle,
    required this.onEditName,
  });

  final String initial;
  final String name;
  final String subtitle;
  final VoidCallback onEditName;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(ProfileDimens.headerSide,
          ProfileDimens.headerTop, ProfileDimens.headerSide, ProfileDimens.headerBottom),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(bottom: BorderSide(color: c.outline)),
      ),
      child: Row(children: [
        Container(
          width: ProfileDimens.avatarSize,
          height: ProfileDimens.avatarSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.primary,
            borderRadius: BorderRadius.circular(ProfileDimens.avatarRadius),
          ),
          child: Text(initial,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                  fontSize: ProfileDimens.avatarFontSize,
                  fontWeight: FontWeight.w700,
                  color: c.onPrimary)),
        ),
        const SizedBox(width: ProfileDimens.headerGap),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name,
                style: TextStyle(
                    fontSize: ProfileDimens.nameFontSize,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary)),
            Text(subtitle,
                style: TextStyle(
                    fontSize: ProfileDimens.headerSubtitleFontSize, color: c.textSecondary)),
          ]),
        ),
        const SizedBox(width: ProfileDimens.headerGap),
        Semantics(
          container: true,
          button: true,
          label: ProfileStrings.editName,
          excludeSemantics: true,
          child: Material(
            color: c.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ProfileDimens.editButtonRadius),
              side: BorderSide(color: c.outline),
            ),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ProfileDimens.editButtonRadius)),
              onTap: onEditName,
              child: SizedBox.square(
                dimension: ProfileDimens.editButtonSize,
                child: Icon(LucideIcons.pencil, size: ProfileDimens.editIcon, color: c.textPrimary),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
