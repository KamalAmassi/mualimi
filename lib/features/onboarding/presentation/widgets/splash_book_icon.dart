import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'splash_dimens.dart';

/// The open-book mark from the Splash design, drawn from the design's own
/// SVG path. The stroke uses `currentColor`, supplied by [color].
class SplashBookIcon extends StatelessWidget {
  const SplashBookIcon({super.key, required this.color});

  final Color color;

  static const _path = 'M2 4h6a4 4 0 0 1 4 4v13a3 3 0 0 0-3-3H2z M22 4h-6a4 4 0 0 0-4 4v13a3 3 0 0 1 3-3h7z';

  static const _svg = '<svg xmlns="http://www.w3.org/2000/svg" '
      'viewBox="0 0 ${SplashDimens.iconViewBox} ${SplashDimens.iconViewBox}" '
      'fill="none" stroke="currentColor" stroke-width="${SplashDimens.iconStroke}" '
      'stroke-linecap="round" stroke-linejoin="round"><path d="$_path"/></svg>';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _svg,
      width: SplashDimens.icon,
      height: SplashDimens.icon,
      theme: SvgTheme(currentColor: color),
      excludeFromSemantics: true,
    );
  }
}
