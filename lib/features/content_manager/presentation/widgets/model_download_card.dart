import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/tutor_engine_state.dart';
import '../../../../core/utils/byte_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/model_download_controller.dart';

/// Download / progress / retry card for the tutor model. Reads only
/// [TutorEngineState]; the controller drives it.
class ModelDownloadCard extends GetView<ModelDownloadController> {
  const ModelDownloadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.engineState.value;
      return AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          switch (state) {
            Downloading(:final bytes, :final progress) =>
              Text('${(progress * 100).round()}% · ${ByteFormatter.format(bytes)}'),
            Verifying() => const Text(AppStrings.verifying),
            Assembling() => const Text(AppStrings.assembling),
            Paused() => const Text(AppStrings.downloadPaused),
            Failed(:final reason) => Text(reason),
            Downloaded() || Loading() || Ready() => const Text(AppStrings.tutorReady),
            SearchOnly() || Unsupported() => const Text(AppStrings.deviceTooWeak),
            NotDownloaded() => const Text(AppStrings.downloadTutor),
          },
          const SizedBox(height: 12),
          switch (state) {
            NotDownloaded() || Failed() =>
              PrimaryButton(label: AppStrings.startDownload, onPressed: controller.start),
            Downloading() =>
              PrimaryButton(label: AppStrings.pause, onPressed: controller.pause),
            Paused() => PrimaryButton(label: AppStrings.resume, onPressed: controller.resume),
            _ => const SizedBox.shrink(),
          },
        ]),
      );
    });
  }
}
