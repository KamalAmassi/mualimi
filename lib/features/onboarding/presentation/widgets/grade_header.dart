import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import 'grade_dimens.dart';

/// Top bar with the back chevron (right side in RTL) and the screen title.
class GradeHeader extends StatelessWidget {
  const GradeHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outline)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            GradeDimens.headerSidePadding,
            GradeDimens.headerTopPadding,
            GradeDimens.headerSidePadding,
            GradeDimens.headerBottomPadding,
          ),
          child: Row(
            spacing: GradeDimens.headerGap,
            children: [
              SizedBox.square(
                dimension: GradeDimens.backButton,
                child: IconButton(
                  onPressed: onBack,
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(GradeDimens.backButtonRadius),
                    ),
                  ),
                  icon: Icon(
                    LucideIcons.chevronRight,
                    size: GradeDimens.backIcon,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  AppStrings.grade,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: GradeDimens.headerTitleFontSize,
                    fontWeight: FontWeight.w700,
                    height: GradeDimens.headerTitleLineHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
