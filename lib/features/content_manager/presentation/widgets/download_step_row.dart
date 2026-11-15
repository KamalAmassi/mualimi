import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../constants/download_dimens.dart';
import 'download_step_icon.dart';
import 'download_step_state.dart';

/// One checklist row: status marker + title + optional subtitle.
class DownloadStepRow extends StatelessWidget {
  const DownloadStepRow({
    super.key,
    required this.state,
    required this.title,
    this.subtitle,
  });

  final DownloadStepState state;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final titleColor = state == DownloadStepState.pending ? c.textSecondary : c.textPrimary;
    final subtitleColor = state == DownloadStepState.error ? c.error : c.textSecondary;
    final sub = subtitle;
    return Row(
      children: [
        DownloadStepIcon(state: state),
        const SizedBox(width: DownloadDimens.stepRowGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: DownloadDimens.stepTitleFontSize,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
              if (sub != null)
                Text(
                  sub,
                  style: TextStyle(fontSize: DownloadDimens.stepSubtitleFontSize, color: subtitleColor),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
