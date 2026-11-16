import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../constants/download_dimens.dart';
import '../constants/download_strings.dart';

/// Footer progress marker: three bars (14/14/28) and the step label.
class DownloadStepBars extends StatelessWidget {
  const DownloadStepBars({super.key, this.label = DownloadStrings.stepLabel});

  final String label;

  static const List<double> barWidths = [
    DownloadDimens.stepBarShortWidth,
    DownloadDimens.stepBarShortWidth,
    DownloadDimens.stepBarLongWidth,
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        for (var i = 0; i < barWidths.length; i++) ...[
          if (i > 0) const SizedBox(width: DownloadDimens.stepBarGap),
          Container(
            width: barWidths[i],
            height: DownloadDimens.stepBarHeight,
            decoration: BoxDecoration(
              color: c.primary,
              borderRadius: BorderRadius.circular(DownloadDimens.stepBarRadius),
            ),
          ),
        ],
        const SizedBox(width: DownloadDimens.stepBarGap + DownloadDimens.stepLabelGap),
        Flexible(
          child: Text(
            label,
            style: TextStyle(fontSize: DownloadDimens.stepLabelFontSize, color: c.textSecondary),
          ),
        ),
      ],
    );
  }
}
