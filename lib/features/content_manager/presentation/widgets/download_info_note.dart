import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../constants/download_dimens.dart';
import 'download_icon.dart';
import 'download_icons.dart';

/// Small muted note with an info icon, placed under the download banner.
class DownloadInfoNote extends StatelessWidget {
  const DownloadInfoNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.textSecondary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DownloadIcon(DownloadIcons.info, color: color, size: DownloadDimens.noteIconSize),
        const SizedBox(width: DownloadDimens.noteGap),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: DownloadDimens.noteFontSize,
              height: DownloadDimens.noteLineHeight,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
