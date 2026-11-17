import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../content_manager/presentation/constants/grade_ordinals.dart';
import 'grade_dimens.dart';

/// One grade in the grid: selectable, selected (with a check badge), or not
/// offered yet ("قريباً", not tappable).
class GradeTile extends StatelessWidget {
  const GradeTile({
    super.key,
    required this.grade,
    required this.available,
    required this.selected,
    required this.onTap,
  });

  final int grade;
  final bool available;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(GradeDimens.tileRadius);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: selected ? colors.tint : colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: selected ? colors.primary : colors.outline,
              width: selected ? GradeDimens.tileSelectedBorder : GradeDimens.tileBorder,
            ),
          ),
          child: InkWell(
            borderRadius: radius,
            onTap: available ? onTap : null,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: GradeDimens.tileMinHeight,
                minWidth: double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: GradeDimens.tileVerticalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: GradeDimens.tileLineGap,
                  children: [
                    Text(
                      AppStrings.gradePrefix,
                      style: TextStyle(
                        color: selected ? colors.primary : colors.textSecondary,
                        fontSize: GradeDimens.tileCaptionFontSize,
                      ),
                    ),
                    Text(
                      GradeOrdinals.of(grade),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected
                            ? colors.primary
                            : available
                                ? colors.textPrimary
                                : colors.textBody,
                        fontSize: selected
                            ? GradeDimens.tileSelectedOrdinalFontSize
                            : GradeDimens.tileOrdinalFontSize,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                    if (!available) const _ComingSoonBadge(),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (selected)
          const Positioned(top: GradeDimens.checkTop, left: GradeDimens.checkLeft, child: _CheckBadge()),
      ],
    );
  }
}

class _ComingSoonBadge extends StatelessWidget {
  const _ComingSoonBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(top: GradeDimens.badgeTopGap),
      padding: const EdgeInsets.symmetric(horizontal: GradeDimens.badgeHorizontalPadding),
      decoration: BoxDecoration(
        color: colors.infoContainer,
        borderRadius: BorderRadius.circular(GradeDimens.badgeRadius),
      ),
      child: Text(
        AppStrings.comingSoon,
        style: TextStyle(color: colors.onInfoContainer, fontSize: GradeDimens.badgeFontSize),
      ),
    );
  }
}

class _CheckBadge extends StatelessWidget {
  const _CheckBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: GradeDimens.checkSize,
      height: GradeDimens.checkSize,
      decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
      child: Icon(LucideIcons.check, size: GradeDimens.checkIcon, color: colors.onPrimary),
    );
  }
}
