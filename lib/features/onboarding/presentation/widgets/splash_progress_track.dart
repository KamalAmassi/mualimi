import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../controllers/splash_timing.dart';
import 'splash_dimens.dart';

/// Indeterminate progress under the brand: the fill sweeps between the
/// reading edge and the far edge until the splash leaves. It stays at the
/// reading edge when the platform asks for reduced motion.
class SplashProgressTrack extends StatefulWidget {
  const SplashProgressTrack({super.key});

  @override
  State<SplashProgressTrack> createState() => _SplashProgressTrackState();
}

class _SplashProgressTrackState extends State<SplashProgressTrack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweep =
      AnimationController(vsync: this, duration: SplashTiming.progressSweep);
  late final Animation<double> _position =
      CurvedAnimation(parent: _sweep, curve: Curves.easeInOut);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _sweep.reset();
    } else if (!_sweep.isAnimating) {
      _sweep.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(SplashDimens.trackRadius);
    return Container(
      width: SplashDimens.trackWidth,
      height: SplashDimens.trackHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: colors.heroTrack, borderRadius: radius),
      child: AnimatedBuilder(
        animation: _position,
        builder: (_, fill) => Align(
          alignment: AlignmentDirectional.lerp(
              AlignmentDirectional.centerStart, AlignmentDirectional.centerEnd, _position.value)!,
          child: fill,
        ),
        child: FractionallySizedBox(
          widthFactor: SplashDimens.trackFill,
          heightFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(color: colors.heroHighlight, borderRadius: radius),
          ),
        ),
      ),
    );
  }
}
