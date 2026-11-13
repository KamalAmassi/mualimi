import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'splash_dimens.dart';
import 'splash_strings.dart';

/// Bottom of the Splash: a static, decorative progress track and the
/// curriculum line. The fill starts at the reading edge (right in RTL).
class SplashFooter extends StatelessWidget {
  const SplashFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(SplashDimens.trackRadius);
    return Padding(
      padding: const EdgeInsets.only(bottom: SplashDimens.footerBottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: SplashDimens.gap,
        children: [
          Container(
            width: SplashDimens.trackWidth,
            height: SplashDimens.trackHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: c.heroTrack, borderRadius: radius),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: FractionallySizedBox(
                widthFactor: SplashDimens.trackFill,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: c.heroHighlight, borderRadius: radius),
                ),
              ),
            ),
          ),
          Text(
            SplashStrings.footer,
            textAlign: TextAlign.center,
            style: TextStyle(color: c.onHeroMuted, fontSize: SplashDimens.footerFontSize),
          ),
        ],
      ),
    );
  }
}
