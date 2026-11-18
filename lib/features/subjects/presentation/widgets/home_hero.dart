import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'home_dimens.dart';
import 'home_hero_chip.dart';
import 'home_strings.dart';

/// Purple header: greeting, name, grade and the offline / tutor chips.
class HomeHero extends StatelessWidget {
  const HomeHero({
    super.key,
    required this.greeting,
    required this.name,
    required this.gradeLabel,
    required this.online,
    required this.bottomPadding,
  });

  final String greeting;
  final String name;
  final String? gradeLabel;
  final bool online;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(color: c.hero),
      child: Stack(children: [
        PositionedDirectional(
          top: HomeDimens.ringTop,
          end: HomeDimens.ringLeft,
          child: Opacity(
            opacity: HomeDimens.ringOpacity,
            child: Container(
              width: HomeDimens.ringSize,
              height: HomeDimens.ringSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: c.heroRing, width: HomeDimens.ringBorder),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(AppSizes.pagePadding,
              HomeDimens.heroTop + MediaQuery.paddingOf(context).top,
              AppSizes.pagePadding, bottomPadding),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(greeting,
                      style: TextStyle(fontSize: HomeDimens.greetingFontSize, color: c.onHeroMuted)),
                  if (name.isNotEmpty)
                    Text(name,
                        style: TextStyle(
                            fontSize: HomeDimens.nameFontSize,
                            fontWeight: FontWeight.w700,
                            color: c.onHero)),
                ]),
              ),
              if (gradeLabel != null) HomeHeroChip(label: gradeLabel!),
            ]),
            const SizedBox(height: HomeDimens.chipsTop),
            Wrap(spacing: HomeDimens.chipGap, runSpacing: HomeDimens.chipGap, children: [
              const HomeHeroChip(label: HomeStrings.offlineReady, icon: LucideIcons.check),
              HomeHeroChip(
                label: online ? HomeStrings.tutorOnline : HomeStrings.tutorOffline,
                icon: LucideIcons.sparkles,
              ),
            ]),
          ]),
        ),
      ]),
    );
  }
}
