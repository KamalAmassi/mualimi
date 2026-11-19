import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../content_manager/presentation/constants/grade_ordinals.dart';
import 'profile_sheet_dimens.dart';
import 'profile_sheet_strings.dart';

/// One grade in the change-grade grid. The student's grade reads
/// «صفك الحالي»; a grade not offered yet reads «قريباً» and cannot be tapped.
class ChangeGradeTile extends StatelessWidget {
  const ChangeGradeTile({
    super.key,
    required this.grade,
    required this.isCurrent,
    required this.available,
    required this.highlighted,
    required this.onTap,
  });

  final int grade;
  final bool isCurrent;
  final bool available;
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(ProfileSheetDimens.tileRadius);
    final caption = isCurrent
        ? ProfileSheetStrings.currentGrade
        : available
            ? null
            : AppStrings.comingSoon;
    final Color textColor = highlighted
        ? c.onTint
        : available || isCurrent
            ? c.textPrimary
            : c.textBody;
    return Semantics(
      selected: highlighted,
      child: Material(
        color: highlighted ? c.tint : c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: highlighted ? c.primary : c.outline,
            width: highlighted ? ProfileSheetDimens.tileSelectedBorder : ProfileSheetDimens.tileBorder,
          ),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: ProfileSheetDimens.tileMinHeight,
              minWidth: double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: ProfileSheetDimens.tilePaddingV),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  GradeOrdinals.of(grade),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ProfileSheetDimens.tileFontSize,
                    fontWeight: highlighted ? FontWeight.w700 : FontWeight.w400,
                    color: textColor,
                  ),
                ),
                if (caption != null)
                  Text(
                    caption,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ProfileSheetDimens.tileCaptionFontSize,
                      fontWeight: isCurrent ? FontWeight.w500 : FontWeight.w400,
                      color: isCurrent
                          ? (highlighted ? c.onTint : c.textSecondary)
                          : c.onInfoContainer,
                    ),
                  ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
