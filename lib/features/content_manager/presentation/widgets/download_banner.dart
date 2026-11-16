import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../constants/download_dimens.dart';
import 'download_icon.dart';

/// Colour family of a [DownloadBanner].
enum DownloadBannerVariant { success, warning }

/// Tinted note with an icon, an optional bold title (own line) or bold
/// lead (inline, before the body), and a body.
class DownloadBanner extends StatelessWidget {
  const DownloadBanner({
    super.key,
    required this.variant,
    required this.iconPath,
    required this.body,
    this.title,
    this.lead,
  });

  final DownloadBannerVariant variant;
  final String iconPath;
  final String body;
  final String? title;
  final String? lead;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final success = variant == DownloadBannerVariant.success;
    final background = success ? c.successContainer : c.warningContainer;
    final iconColor = success ? c.success : c.warning;
    final textColor = success ? c.onSuccessContainer : c.onWarningContainer;
    final head = title;
    final inline = lead;
    final bodyStyle = TextStyle(
      fontSize: DownloadDimens.bannerBodyFontSize,
      height: head == null ? DownloadDimens.bannerBodyLineHeight : DownloadDimens.bannerBodyLineHeightTitled,
      color: textColor,
    );
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: DownloadDimens.bannerPaddingHorizontal,
        vertical: DownloadDimens.bannerPaddingVertical,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(DownloadDimens.bannerRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DownloadIcon(iconPath, color: iconColor, size: DownloadDimens.bannerIconSize),
          const SizedBox(width: DownloadDimens.bannerGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (head != null) ...[
                  Text(
                    head,
                    style: TextStyle(
                      fontSize: DownloadDimens.bannerTitleFontSize,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: DownloadDimens.bannerTitleGap),
                ],
                Text.rich(
                  TextSpan(
                    children: [
                      if (inline != null)
                        TextSpan(text: '$inline ', style: const TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: body),
                    ],
                  ),
                  style: bodyStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
