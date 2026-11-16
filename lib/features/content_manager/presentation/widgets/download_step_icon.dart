import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../constants/download_dimens.dart';
import 'download_icon.dart';
import 'download_icons.dart';
import 'download_step_state.dart';

/// 28px status marker of a checklist row.
class DownloadStepIcon extends StatelessWidget {
  const DownloadStepIcon({super.key, required this.state});

  final DownloadStepState state;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return switch (state) {
      DownloadStepState.done => _filled(c.success, DownloadIcons.check, c.onPrimary),
      DownloadStepState.error => _filled(c.error, DownloadIcons.close, c.onPrimary),
      DownloadStepState.active => _ring(
          c.primaryText,
          DownloadDimens.stepActiveRingWidth,
          child: Container(
            width: DownloadDimens.stepActiveDotSize,
            height: DownloadDimens.stepActiveDotSize,
            decoration: BoxDecoration(color: c.primaryText, shape: BoxShape.circle),
          ),
        ),
      DownloadStepState.pending => _ring(c.outline, DownloadDimens.stepPendingRingWidth),
    };
  }

  Widget _filled(Color background, String glyph, Color glyphColor) {
    return Container(
      width: DownloadDimens.stepIconSize,
      height: DownloadDimens.stepIconSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: DownloadIcon(
        glyph,
        color: glyphColor,
        size: DownloadDimens.stepGlyphSize,
        strokeWidth: DownloadDimens.stepIconStroke,
      ),
    );
  }

  Widget _ring(Color color, double width, {Widget? child}) {
    return Container(
      width: DownloadDimens.stepIconSize,
      height: DownloadDimens.stepIconSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: width),
      ),
      child: child,
    );
  }
}
