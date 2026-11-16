import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../constants/download_dimens.dart';
import 'download_step_row.dart';

/// The checklist card that holds the download step rows.
class DownloadStepList extends StatelessWidget {
  const DownloadStepList({super.key, required this.steps});

  final List<DownloadStepRow> steps;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(DownloadDimens.cardPadding),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(DownloadDimens.cardRadius),
        border: Border.all(color: c.outline, width: DownloadDimens.cardBorderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            if (i > 0) const SizedBox(height: DownloadDimens.stepListGap),
            steps[i],
          ],
        ],
      ),
    );
  }
}
