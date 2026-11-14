import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/primary_button.dart';
import 'tutor_sizes.dart';

/// Shown for subjects the tutor does not support yet (math).
class MathUnavailableView extends StatelessWidget {
  const MathUnavailableView({
    super.key,
    required this.subjectName,
    required this.onOpenSubject,
    required this.onChooseOther,
  });

  final String subjectName;
  final VoidCallback onOpenSubject;
  final VoidCallback onChooseOther;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.xxl),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: TutorSizes.emptyIcon,
            height: TutorSizes.emptyIcon,
            decoration: BoxDecoration(
              color: c.infoContainer,
              borderRadius: BorderRadius.circular(TutorSizes.emptyIconRadius),
            ),
            child: Icon(LucideIcons.sparkles,
                size: AppSizes.iconLg - 8, color: c.info),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(AppStrings.mathSoonTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary)),
          const SizedBox(height: AppSizes.md),
          Text(AppStrings.mathSoonBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14.5, height: 1.75, color: c.textSecondary)),
          const SizedBox(height: AppSizes.xxl),
          PrimaryButton(
            label: '${AppStrings.openSubjectLessons} $subjectName',
            icon: LucideIcons.bookOpen,
            onPressed: onOpenSubject,
          ),
          const SizedBox(height: AppSizes.md),
          PrimaryButton(
            label: AppStrings.chooseOtherSubject,
            onPressed: onChooseOther,
            outlined: true,
          ),
        ]),
      ),
    );
  }
}
