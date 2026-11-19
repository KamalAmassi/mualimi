import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failures.dart';
import '../constants/download_dimens.dart';
import '../constants/download_strings.dart';
import '../controllers/pack_download_controller.dart';
import '../widgets/download_action_button.dart';
import '../widgets/download_failed_checklist.dart';
import '../widgets/download_icons.dart';
import '../widgets/download_scaffold.dart';
import '../widgets/download_status_header.dart';
import '../widgets/download_step_bars.dart';

/// Failed state of the pack download: a corrupted file (integrity check)
/// or any other failure.
class DownloadFailedPage extends StatelessWidget {
  const DownloadFailedPage({super.key, required this.controller});

  final PackDownloadController controller;

  @override
  Widget build(BuildContext context) {
    final corrupted = controller.failure.value is IntegrityFailure;
    return DownloadScaffold(
      title: DownloadStrings.packTitle,
      onBack: () => Navigator.maybePop(context),
      padding: const EdgeInsets.symmetric(
        vertical: DownloadDimens.statusBodyPaddingVertical,
        horizontal: DownloadDimens.bodyPadding,
      ),
      gap: DownloadDimens.statusBodyGap,
      footer: [
        const DownloadStepBars(),
        DownloadActionButton(
          label: corrupted ? DownloadStrings.redownload : AppStrings.retry,
          iconPath: corrupted ? DownloadIcons.download : DownloadIcons.refresh,
          onPressed: controller.start,
        ),
      ],
      children: corrupted
          ? const [
              DownloadStatusHeader(
                variant: DownloadStatusVariant.warning,
                iconPath: DownloadIcons.shieldCheck,
                title: DownloadStrings.integrityTitle,
                body: DownloadStrings.integrityBody,
              ),
              DownloadFailedChecklist(),
            ]
          : const [
              DownloadStatusHeader(
                variant: DownloadStatusVariant.warning,
                iconPath: DownloadIcons.info,
                title: AppStrings.downloadFailed,
                body: DownloadStrings.failedBody,
              ),
            ],
    );
  }
}
