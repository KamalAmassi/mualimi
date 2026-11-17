import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'welcome_dimens.dart';
import 'welcome_strings.dart';

/// The card listing what the app offers, one row per feature.
class WelcomeFeatureCard extends StatelessWidget {
  const WelcomeFeatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(WelcomeDimens.cardRadius),
      ),
      child: const Column(
        spacing: WelcomeDimens.featureGap,
        children: [
          _FeatureRow(
            icon: LucideIcons.bookOpen,
            title: WelcomeStrings.lessonsTitle,
            description: WelcomeStrings.lessonsDescription,
          ),
          _FeatureRow(
            icon: LucideIcons.sparkles,
            title: WelcomeStrings.tutorTitle,
            description: WelcomeStrings.tutorDescription,
          ),
          _FeatureRow(
            icon: LucideIcons.shieldCheck,
            title: WelcomeStrings.sourceTitle,
            description: WelcomeStrings.sourceDescription,
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.title, required this.description});

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      spacing: AppSizes.md,
      children: [
        Container(
          width: WelcomeDimens.featureTile,
          height: WelcomeDimens.featureTile,
          decoration: BoxDecoration(
            color: colors.tint,
            borderRadius: BorderRadius.circular(WelcomeDimens.featureTileRadius),
          ),
          child: Icon(icon, size: WelcomeDimens.featureIcon, color: colors.primary),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: WelcomeDimens.featureTitleFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: TextStyle(color: colors.textSecondary, fontSize: WelcomeDimens.featureDescriptionFontSize),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
