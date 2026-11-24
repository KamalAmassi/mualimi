import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'splash_dimens.dart';
import 'splash_progress_track.dart';
import 'splash_strings.dart';

/// Bottom of the Splash: the progress track and the curriculum line.
class SplashFooter extends StatelessWidget {
  const SplashFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: SplashDimens.footerBottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: SplashDimens.gap,
        children: [
          const SplashProgressTrack(),
          Text(
            SplashStrings.footer,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.onHeroMuted, fontSize: SplashDimens.footerFontSize),
          ),
        ],
      ),
    );
  }
}
