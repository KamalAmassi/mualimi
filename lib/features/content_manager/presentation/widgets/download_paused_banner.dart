import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../constants/download_strings.dart';
import '../controllers/download_paused_variant.dart';
import 'download_banner.dart';
import 'download_icons.dart';

/// Warning banner of the paused screen: why the download stopped and
/// what happens next.
class DownloadPausedBanner extends StatelessWidget {
  const DownloadPausedBanner({super.key, required this.variant});

  final DownloadPausedVariant variant;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      DownloadPausedVariant.user => const DownloadBanner(
          variant: DownloadBannerVariant.warning,
          iconPath: DownloadIcons.pause,
          title: AppStrings.downloadPaused,
          body: DownloadStrings.pausedSavedNote,
        ),
      DownloadPausedVariant.network => const DownloadBanner(
          variant: DownloadBannerVariant.warning,
          iconPath: DownloadIcons.wifiOff,
          title: DownloadStrings.connectionLostTitle,
          body: DownloadStrings.connectionLostBody,
        ),
      DownloadPausedVariant.wifi => const DownloadBanner(
          variant: DownloadBannerVariant.warning,
          iconPath: DownloadIcons.wifiOff,
          title: AppStrings.waitingForWifi,
          body: DownloadStrings.resumeTipBody,
        ),
    };
  }
}
