import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../constants/download_dimens.dart';
import 'download_icon.dart';

/// Colour family of the [DownloadStatusHeader] tile.
enum DownloadStatusVariant { error, warning }

/// Centered status block: tinted 84px tile with an icon, title and body.
class DownloadStatusHeader extends StatelessWidget {
  const DownloadStatusHeader({
    super.key,
    required this.variant,
    required this.iconPath,
    required this.title,
    required this.body,
  });

  final DownloadStatusVariant variant;
  final String iconPath;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isError = variant == DownloadStatusVariant.error;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: DownloadDimens.statusPaddingHorizontal,
        vertical: DownloadDimens.statusPaddingVertical,
      ),
      child: Column(
        children: [
          Container(
            width: DownloadDimens.statusTileSize,
            height: DownloadDimens.statusTileSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isError ? c.errorContainer : c.warningContainer,
              borderRadius: BorderRadius.circular(DownloadDimens.statusTileRadius),
            ),
            child: DownloadIcon(
              iconPath,
              color: isError ? c.error : c.warning,
              size: DownloadDimens.statusIconSize,
              strokeWidth: DownloadDimens.statusIconStroke,
            ),
          ),
          const SizedBox(height: DownloadDimens.statusGap),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: DownloadDimens.statusTitleFontSize,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: DownloadDimens.statusGap),
          Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: DownloadDimens.statusBodyFontSize,
              height: DownloadDimens.statusBodyLineHeight,
              color: c.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
