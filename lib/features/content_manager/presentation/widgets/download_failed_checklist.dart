import 'package:flutter/material.dart';

import '../constants/download_strings.dart';
import 'download_step_list.dart';
import 'download_step_row.dart';
import 'download_step_state.dart';

/// Checklist of the integrity-failure screen. A checksum mismatch is only
/// detected after the space check passed and the content arrived, so the
/// first two steps are always done.
class DownloadFailedChecklist extends StatelessWidget {
  const DownloadFailedChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    return const DownloadStepList(
      steps: [
        DownloadStepRow(
          state: DownloadStepState.done,
          title: DownloadStrings.spaceCheckStep,
          subtitle: DownloadStrings.spaceCheckDone,
        ),
        DownloadStepRow(
          state: DownloadStepState.done,
          title: DownloadStrings.contentStep,
          subtitle: DownloadStrings.contentDone,
        ),
        DownloadStepRow(
          state: DownloadStepState.error,
          title: DownloadStrings.integrityStep,
          subtitle: DownloadStrings.integrityMismatch,
        ),
      ],
    );
  }
}
