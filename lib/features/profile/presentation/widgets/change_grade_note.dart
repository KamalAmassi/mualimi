import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import 'profile_sheet_dimens.dart';
import 'profile_sheet_strings.dart';

/// What changing the grade downloads and what it keeps.
class ChangeGradeNote extends StatelessWidget {
  const ChangeGradeNote({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: ProfileSheetDimens.notePaddingH, vertical: ProfileSheetDimens.notePaddingV),
        decoration: BoxDecoration(
          color: c.infoContainer,
          borderRadius: BorderRadius.circular(ProfileSheetDimens.noteRadius),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(LucideIcons.info, size: ProfileSheetDimens.noteIcon, color: c.info),
          const SizedBox(width: ProfileSheetDimens.noteGap),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(ProfileSheetStrings.gradeNoteTitle,
                  style: TextStyle(
                      fontSize: ProfileSheetDimens.noteTitleFontSize,
                      fontWeight: FontWeight.w700,
                      color: c.onInfoContainer)),
              const SizedBox(height: ProfileSheetDimens.noteBodyTop),
              Text(ProfileSheetStrings.gradeNoteBody,
                  style: TextStyle(
                      fontSize: ProfileSheetDimens.noteBodyFontSize,
                      height: ProfileSheetDimens.noteBodyLineHeight,
                      color: c.onInfoContainer)),
            ]),
          ),
        ]),
      ),
    );
  }
}
