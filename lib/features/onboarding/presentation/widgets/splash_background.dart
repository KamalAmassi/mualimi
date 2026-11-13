import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'splash_dimens.dart';

/// The three decorative circles behind the Splash content. Offsets are
/// physical (left/right) because the design places them that way.
class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          top: SplashDimens.decoTop,
          left: SplashDimens.decoLeft,
          child: _Circle(size: SplashDimens.decoSize, color: c.heroDeco),
        ),
        Positioned(
          top: SplashDimens.ringTop,
          left: SplashDimens.ringLeft,
          child: _Circle(
            size: SplashDimens.ringSize,
            border: Border.all(
              color: c.heroRing.withValues(alpha: SplashDimens.ringOpacity),
              width: SplashDimens.ringBorder,
            ),
          ),
        ),
        Positioned(
          bottom: SplashDimens.decoDeepBottom,
          right: SplashDimens.decoDeepRight,
          child: _Circle(size: SplashDimens.decoDeepSize, color: c.heroDecoDeep),
        ),
      ],
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.size, this.color, this.border});

  final double size;
  final Color? color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: border),
      ),
    );
  }
}
