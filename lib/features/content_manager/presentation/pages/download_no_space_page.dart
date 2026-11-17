import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../constants/download_dimens.dart';
import '../constants/download_strings.dart';
import '../controllers/pack_download_controller.dart';
import '../widgets/download_action_button.dart';
import '../widgets/download_icons.dart';
import '../widgets/download_scaffold.dart';
import '../widgets/download_status_header.dart';
import '../widgets/download_step_bars.dart';
import '../widgets/space_compare_card.dart';

class DownloadNoSpacePage extends StatelessWidget {
  const DownloadNoSpacePage({super.key, required this.controller});

  final PackDownloadController controller;

  @override
  Widget build(BuildContext context) {
    final f = controller.failure.value;
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
          label: DownloadStrings.checkAgain,
          iconPath: DownloadIcons.refresh,
          onPressed: controller.start,
        ),
      ],
      children: [
        const DownloadStatusHeader(
          variant: DownloadStatusVariant.error,
          iconPath: DownloadIcons.phone,
          title: DownloadStrings.noSpaceTitle,
          body: DownloadStrings.noSpaceBody,
        ),
        if (f is NotEnoughSpaceFailure)
          SpaceCompareCard(requiredBytes: f.requiredBytes, availableBytes: f.freeBytes),
      ],
    );
  }
}
