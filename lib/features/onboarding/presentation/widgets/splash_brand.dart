import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import 'splash_book_icon.dart';
import 'splash_dimens.dart';
import 'splash_strings.dart';

/// Centre block of the Splash: logo box, app name and tagline.
class SplashBrand extends StatelessWidget {
  const SplashBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: SplashDimens.gap,
      children: [
        Container(
          width: SplashDimens.logoBox,
          height: SplashDimens.logoBox,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.heroChip,
            borderRadius: BorderRadius.circular(SplashDimens.logoRadius),
            border: Border.all(color: c.heroTrack, width: SplashDimens.logoBorder),
          ),
          child: SplashBookIcon(color: c.onHero),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text.rich(
            TextSpan(
              text: AppStrings.appName,
              children: [
                TextSpan(text: SplashStrings.nameDot, style: TextStyle(color: c.heroHighlight)),
              ],
            ),
            style: TextStyle(
              color: c.onHero,
              fontSize: SplashDimens.nameFontSize,
              fontWeight: FontWeight.w700,
              height: SplashDimens.nameLineHeight,
              letterSpacing: 0,
            ),
          ),
        ),
        Text(
          SplashStrings.tagline,
          textAlign: TextAlign.center,
          style: TextStyle(color: c.onHeroMuted, fontSize: SplashDimens.taglineFontSize),
        ),
      ],
    );
  }
}
