import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'splash_strings.dart';
import 'welcome_dimens.dart';
import 'welcome_strings.dart';

/// Hero block at the top of the Welcome screen.
class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: colors.hero,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(WelcomeDimens.headerRadius)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: WelcomeDimens.ringTop,
            left: WelcomeDimens.ringLeft,
            child: Container(
              width: WelcomeDimens.ringSize,
              height: WelcomeDimens.ringSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.heroRing.withValues(alpha: WelcomeDimens.ringOpacity),
                  width: WelcomeDimens.ringBorder,
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.xxl,
                WelcomeDimens.headerTopPadding,
                AppSizes.xxl,
                WelcomeDimens.headerBottomPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: AppStrings.appName,
                          children: [
                            TextSpan(text: SplashStrings.nameDot, style: TextStyle(color: colors.heroHighlight)),
                          ],
                        ),
                        style: TextStyle(
                          color: colors.onHero,
                          fontSize: WelcomeDimens.brandFontSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      const Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: FittedBox(fit: BoxFit.scaleDown, child: _OfflineChip()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: WelcomeDimens.headerTitleGap),
                  Text(
                    WelcomeStrings.title,
                    style: TextStyle(
                      color: colors.onHero,
                      fontSize: WelcomeDimens.titleFontSize,
                      fontWeight: FontWeight.w700,
                      height: WelcomeDimens.titleLineHeight,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    WelcomeStrings.subtitle,
                    style: TextStyle(color: colors.onHeroMuted, fontSize: WelcomeDimens.subtitleFontSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineChip extends StatelessWidget {
  const _OfflineChip();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: WelcomeDimens.chipHorizontalPadding, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: colors.heroChip,
        borderRadius: BorderRadius.circular(AppSizes.radiusChip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: WelcomeDimens.chipGap,
        children: [
          Icon(LucideIcons.wifiOff, size: WelcomeDimens.chipIcon, color: colors.onHero),
          Text(
            WelcomeStrings.offlineChip,
            style: TextStyle(
              color: colors.onHero,
              fontSize: WelcomeDimens.chipFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
