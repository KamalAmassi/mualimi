import 'package:flutter/material.dart';

import '../constants/download_strings.dart';
import 'download_step_list.dart';
import 'download_step_row.dart';
import 'download_step_state.dart';

/// Checklist of the download progress screen: space check, content,
/// integrity check, install. A done step shows its result where the design
/// has one; otherwise each step explains what it does.
class DownloadProgressChecklist extends StatelessWidget {
  const DownloadProgressChecklist({super.key, required this.states, this.contentHint})
      : assert(states.length == 4, 'one state per step');

  final List<DownloadStepState> states;

  /// Replaces the content step subtitle while that step is not done.
  final String? contentHint;

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
          subtitle: content == DownloadStepState.done ? DownloadStrings.contentDone : contentHint ?? DownloadStrings.contentStepHint,
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
