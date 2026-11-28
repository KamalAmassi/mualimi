import 'package:flutter/material.dart';

import '../constants/download_strings.dart';
import 'download_step_list.dart';
import 'download_step_row.dart';
import 'download_step_state.dart';

/// Checklist of the download progress screen: space check, content,
/// integrity check, install. A done step shows its result where the design
/// has one; otherwise each step explains what it does.
class DownloadProgressChecklist extends StatelessWidget {
  const DownloadProgressChecklist({super.key, required this.states})
      : assert(states.length == 4, 'one state per step');

  final List<DownloadStepState> states;

  @override
  Widget build(BuildContext context) {
    final [space, content, integrity, install] = states;
    return DownloadStepList(
      steps: [
        DownloadStepRow(
          state: space,
          title: DownloadStrings.spaceCheckStep,
          subtitle: space == DownloadStepState.done ? DownloadStrings.spaceCheckDone : null,
        ),
        DownloadStepRow(
          state: content,
          title: DownloadStrings.contentStep,
          subtitle: content == DownloadStepState.done ? DownloadStrings.contentDone : DownloadStrings.contentStepHint,
        ),
        DownloadStepRow(
          state: integrity,
          title: DownloadStrings.integrityStep,
          subtitle: DownloadStrings.integrityStepHint,
        ),
        DownloadStepRow(
          state: install,
          title: DownloadStrings.installStep,
          subtitle: DownloadStrings.installStepHint,
        ),
      ],
    );
  }
}
