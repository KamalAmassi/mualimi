import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../constants/download_dimens.dart';

/// The 10px hero progress bar; the fill grows from the start (right in RTL).
class DownloadHeroBar extends StatelessWidget {
  const DownloadHeroBar({super.key, required this.progress, required this.fillColor});

  /// Fill in 0..1 (clamped).
  final double progress;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(DownloadDimens.heroBarRadius);
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        height: DownloadDimens.heroBarHeight,
        color: context.colors.heroTrack,
        alignment: AlignmentDirectional.centerStart,
        child: FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          heightFactor: 1,
          child: DecoratedBox(decoration: BoxDecoration(color: fillColor, borderRadius: radius)),
        ),
      ),
    );
  }
}
