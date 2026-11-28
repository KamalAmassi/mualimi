import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../constants/download_strings.dart';
import '../controllers/download_pack_line.dart';
import '../controllers/download_steps_ui.dart';
import '../controllers/download_ui_state.dart';
import '../controllers/pack_download_controller.dart';
import '../widgets/download_action_button.dart';
import '../widgets/download_banner.dart';
import '../widgets/download_hero_card.dart';
import '../widgets/download_icons.dart';
import '../widgets/download_info_note.dart';
import '../widgets/download_progress_checklist.dart';
import '../widgets/download_scaffold.dart';
import '../widgets/download_step_bars.dart';

/// Pack download in progress: downloading, then the integrity check and
/// assembly. Back leaves the screen without canceling the download.
class DownloadProgressPage extends StatelessWidget {
  const DownloadProgressPage({super.key, required this.controller});

  final PackDownloadController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final c = controller;
      final pack = c.pack.value;
      final state = c.ui.value;
      return DownloadScaffold(
        title: DownloadStrings.packTitle,
        onBack: () => Navigator.maybePop(context),
        footer: [
          const DownloadStepBars(),
          DownloadActionButton(
            label: AppStrings.pause,
            iconPath: DownloadIcons.pause,
            variant: DownloadButtonVariant.outlined,
            // Only the transfer can pause; the integrity check runs to the end.
            onPressed: state == DownloadUiState.downloading ? c.pause : null,
          ),
        ],
        children: [
          DownloadHeroCard(
            title: pack == null ? DownloadStrings.packTitle : DownloadPackLine.title(pack),
            subtitle: pack == null ? '' : DownloadPackLine.details(pack),
            percent: DownloadPackLine.percentOf(c.bytesDone.value, c.totalBytes.value),
            progress: c.progress.value,
            sideText: DownloadStrings.onceOnly,
          ),
          DownloadProgressChecklist(
            states: state.stepsFor(c.failure.value, jobStarted: c.bytesDone.value > 0),
          ),
          const DownloadBanner(
            variant: DownloadBannerVariant.success,
            iconPath: DownloadIcons.refresh,
            lead: DownloadStrings.resumeTipLead,
            body: DownloadStrings.resumeTipBody,
          ),
          const DownloadInfoNote(text: DownloadStrings.worksOffline),
        ],
      );
    });
  }
}
