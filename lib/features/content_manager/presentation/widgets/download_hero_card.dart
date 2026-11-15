import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../constants/download_dimens.dart';
import '../constants/download_strings.dart';
import 'download_hero_bar.dart';
import 'download_icon.dart';
import 'download_icons.dart';

/// Colour of the hero progress fill: active download vs paused.
enum DownloadHeroFill { highlight, muted }

/// Purple pack card with title, big percent numeral and a progress bar.
class DownloadHeroCard extends StatelessWidget {
  const DownloadHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.percent,
    required this.progress,
    this.sideText,
    this.fill = DownloadHeroFill.highlight,
    this.gap = DownloadDimens.heroGap,
  });

  final String title;
  final String subtitle;
  final int percent;

  /// Bar fill in 0..1 (clamped).
  final double progress;

  /// Optional small text at the end of the percent row.
  final String? sideText;
  final DownloadHeroFill fill;

  /// Vertical gap between sections (16, or 14 on the paused screen).
  final double gap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final muted = TextStyle(fontSize: DownloadDimens.heroSideTextFontSize, color: c.onHeroMuted);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: c.hero, borderRadius: BorderRadius.circular(DownloadDimens.heroRadius)),
      child: Stack(
        children: [
          Positioned(
            bottom: DownloadDimens.heroRingBottom,
            left: DownloadDimens.heroRingLeft,
            child: Opacity(
              opacity: DownloadDimens.heroRingOpacity,
              child: Container(
                width: DownloadDimens.heroRingSize,
                height: DownloadDimens.heroRingSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: c.heroRing, width: DownloadDimens.heroRingBorderWidth),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(DownloadDimens.heroPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _head(c, muted),
                SizedBox(height: gap),
                _percentRow(c, muted),
                SizedBox(height: gap),
                DownloadHeroBar(
                  progress: progress,
                  fillColor: fill == DownloadHeroFill.highlight ? c.heroHighlight : c.onHeroMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _head(AppColors c, TextStyle muted) {
    return Row(
      children: [
        Container(
          width: DownloadDimens.heroChipSize,
          height: DownloadDimens.heroChipSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.heroChip,
            borderRadius: BorderRadius.circular(DownloadDimens.heroChipRadius),
          ),
          child: DownloadIcon(DownloadIcons.box, color: c.onHero, size: DownloadDimens.heroChipIconSize),
        ),
        const SizedBox(width: DownloadDimens.heroHeadGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: DownloadDimens.heroTitleFontSize,
                  fontWeight: FontWeight.w700,
                  color: c.onHero,
                ),
              ),
              Text(subtitle, style: muted.copyWith(fontSize: DownloadDimens.heroSubtitleFontSize)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _percentRow(AppColors c, TextStyle muted) {
    final side = sideText;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // Scales down only when a large text scale makes it too wide.
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text.rich(
              TextSpan(
                text: '$percent',
                children: const [
                  TextSpan(
                    text: DownloadStrings.percentSign,
                    style: TextStyle(fontSize: DownloadDimens.heroPercentSignFontSize),
                  ),
                ],
              ),
              style: TextStyle(
                fontSize: DownloadDimens.heroPercentFontSize,
                fontWeight: FontWeight.w700,
                height: DownloadDimens.heroPercentLineHeight,
                color: c.onHero,
              ),
            ),
          ),
        ),
        if (side != null) Flexible(child: Text(side, style: muted, textAlign: TextAlign.end)),
      ],
    );
  }
}
