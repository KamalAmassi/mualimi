import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/placeholder_page.dart';
import '../controllers/pack_download_controller.dart';

class DownloadFailedPage extends StatelessWidget {
  const DownloadFailedPage({super.key, required this.controller});

  final PackDownloadController controller;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: AppStrings.downloadFailed,
      status: controller.failure.value?.message,
      actions: [PlaceholderAction(AppStrings.retry, controller.start)],
    );
  }
}
