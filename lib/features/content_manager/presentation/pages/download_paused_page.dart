import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../constants/download_dimens.dart';
import '../constants/download_strings.dart';
import '../controllers/download_pack_line.dart';
import '../controllers/download_paused_variant.dart';
import '../controllers/download_steps_ui.dart';
import '../controllers/pack_download_controller.dart';
import '../widgets/download_action_button.dart';
import '../widgets/download_hero_card.dart';
import '../widgets/download_icons.dart';
import '../widgets/download_paused_banner.dart';
import '../widgets/download_progress_checklist.dart';
import '../widgets/download_scaffold.dart';
import '../widgets/download_step_bars.dart';

/// Paused pack download: stopped by the user, waiting for the network
/// (resumes on its own), or waiting for Wi-Fi. What arrived is kept.
class DownloadPausedPage extends StatelessWidget {
  const DownloadPausedPage({super.key, required this.controller});

  final PackDownloadController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final c = controller;
      final pack = c.pack.value;
      final state = c.ui.value;
      final variant = DownloadPausedVariant.of(state, c.pauseReason.value);
      final jobStarted = c.bytesDone.value > 0;
      final percent = DownloadPackLine.percentOf(c.bytesDone.value, c.totalBytes.value);
      return DownloadScaffold(
        title: DownloadStrings.packTitle,
        onBack: () => Navigator.maybePop(context),
        // Resume and cancel must stay reachable on short screens.
        pinFooter: true,
        footer: [
          const DownloadStepBars(),
          if (variant != DownloadPausedVariant.wifi)
            DownloadActionButton(
              label: variant == DownloadPausedVariant.network ? DownloadStrings.resumeNow : AppStrings.resume,
              iconPath: DownloadIcons.refresh,
              onPressed: c.resume,
            ),
          DownloadActionButton(
            label: AppStrings.cancel,
            variant: DownloadButtonVariant.outlined,
            onPressed: c.cancel,
          ),
        ],
        children: [
          DownloadHeroCard(
            title: pack == null ? DownloadStrings.packTitle : DownloadPackLine.title(pack),
            subtitle: jobStarted
                ? DownloadPackLine.pausedDetails(percent)
                : (pack == null ? '' : DownloadPackLine.details(pack)),
            percent: percent,
            progress: c.progress.value,
            fill: DownloadHeroFill.muted,
            gap: DownloadDimens.heroGapCompact,
          ),
          DownloadPausedBanner(variant: variant),
          DownloadProgressChecklist(
            states: state.stepsFor(c.failure.value, jobStarted: jobStarted),
            contentHint: variant == DownloadPausedVariant.user ? null : DownloadStrings.waitingForConnection,
          ),
        ],
      );
    });
  }
}
