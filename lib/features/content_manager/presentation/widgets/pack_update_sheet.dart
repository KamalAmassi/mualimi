import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/byte_formatter.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/download_ui_state.dart';
import '../controllers/pack_download_controller.dart';

/// Opens the sheet only when the manifest offers a newer pack.
Future<void> showPackUpdateSheetIfAvailable() async {
  final controller = Get.find<PackDownloadController>();
  await controller.checkForUpdate();
  if (controller.offeredPack.value != null) {
    await showAppBottomSheet<void>(const PackUpdateSheet());
  }
}

class PackUpdateSheet extends GetView<PackDownloadController> {
  const PackUpdateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pack = controller.offeredPack.value;
      final busy = controller.ui.value == DownloadUiState.downloading;
      return Column(mainAxisSize: MainAxisSize.min, children: [
        Text(AppStrings.packUpdate, style: Theme.of(context).textTheme.titleMedium),
        if (pack != null) Text('v${pack.version} · ${ByteFormatter.format(pack.size)}'),
        const SizedBox(height: 16),
        PrimaryButton(
          label: busy
              ? '${(controller.progress.value * 100).round()}%'
              : AppStrings.updateNow,
          onPressed: busy ? null : controller.start,
        ),
        const SizedBox(height: 8),
        PrimaryButton(label: AppStrings.later, onPressed: Get.back, outlined: true),
      ]);
    });
  }
}
