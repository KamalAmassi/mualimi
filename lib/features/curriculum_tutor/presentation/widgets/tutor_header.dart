import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'tutor_sizes.dart';

class TutorHeader extends StatelessWidget {
  const TutorHeader({
    super.key,
    required this.online,
    required this.onOpenSaved,
    this.onBack,
  });

  final bool online;
  final VoidCallback onOpenSaved;

  /// Shows a back button when the tutor is a full screen, not a tab.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final statusColor = online ? c.success : c.warning;
    return Container(
      color: c.surface,
      padding:
          const EdgeInsets.fromLTRB(AppSizes.lg, 14, AppSizes.lg, AppSizes.md),
      child: Row(children: [
        if (onBack != null) ...[
          IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: onBack,
            icon: Icon(LucideIcons.arrowRight, color: c.textPrimary),
          ),
          const SizedBox(width: AppSizes.xs),
        ],
        Container(
          width: TutorSizes.headerIcon,
          height: TutorSizes.headerIcon,
          decoration: BoxDecoration(
            color: c.primary,
            borderRadius: BorderRadius.circular(TutorSizes.headerIconRadius),
          ),
          child: Icon(LucideIcons.sparkles,
              color: c.onPrimary, size: AppSizes.iconMd),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(AppStrings.smartTutor,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary)),
            Row(children: [
              Container(
                width: TutorSizes.statusDot,
                height: TutorSizes.statusDot,
                decoration:
                    BoxDecoration(color: statusColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Text(
                online
                    ? AppStrings.tutorOnlineSubtitle
                    : AppStrings.tutorOfflineSubtitle,
                style: TextStyle(
                    fontSize: TutorSizes.textSmall, color: statusColor),
              ),
            ]),
          ]),
        ),
        InkWell(
          onTap: onOpenSaved,
          borderRadius: BorderRadius.circular(TutorSizes.smallButtonRadius),
          child: Container(
            width: TutorSizes.headerIcon,
            height: TutorSizes.headerIcon,
            decoration: BoxDecoration(
              color: c.background,
              borderRadius: BorderRadius.circular(TutorSizes.smallButtonRadius),
            ),
            child: Icon(LucideIcons.bookmark,
                color: c.textPrimary, size: AppSizes.iconMd),
          ),
        ),
      ]),
    );
  }
}
