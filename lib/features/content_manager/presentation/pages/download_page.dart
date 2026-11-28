import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/placeholder_page.dart';
import '../controllers/download_ui_state.dart';
import '../controllers/pack_download_controller.dart';
import 'download_failed_page.dart';
import 'download_no_space_page.dart';
import 'download_paused_page.dart';
import 'download_progress_page.dart';

/// Onboarding step 3/3. The paused / no-space / failed designs are states of
/// this screen, not separate routes.
class DownloadPage extends GetView<PackDownloadController> {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final c = controller;
      switch (c.ui.value) {
        case DownloadUiState.paused:
          return DownloadPausedPage(controller: c);
        case DownloadUiState.noSpace:
          return DownloadNoSpacePage(controller: c);
        case DownloadUiState.failed:
          return DownloadFailedPage(controller: c);
        case DownloadUiState.awaitingNetworkChoice:
          return PlaceholderPage(title: AppStrings.mobileDataTitle, actions: [
            PlaceholderAction(AppStrings.waitForWifi, c.waitForWifi),
            PlaceholderAction(AppStrings.continueOnMobile, c.continueOnMobile),
          ]);
        case DownloadUiState.waitingForWifi:
          return PlaceholderPage(
            title: AppStrings.waitingForWifi,
            actions: [PlaceholderAction(AppStrings.cancel, c.cancel)],
          );
        case DownloadUiState.downloading:
        case DownloadUiState.verifying:
        case DownloadUiState.assembling:
          return DownloadProgressPage(controller: c);
        case DownloadUiState.completed:
          return const PlaceholderPage(title: AppStrings.downloadDone);
        case DownloadUiState.idle:
          return PlaceholderPage(
            title: AppStrings.download,
            actions: [PlaceholderAction(AppStrings.startDownload, c.start)],
          );
      }
    });
  }
}
