import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/placeholder_page.dart';
import '../controllers/pack_download_controller.dart';

class DownloadPausedPage extends StatelessWidget {
  const DownloadPausedPage({super.key, required this.controller});

  final PackDownloadController controller;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: AppStrings.downloadPaused,
      actions: [
        PlaceholderAction(AppStrings.resume, controller.resume),
        PlaceholderAction(AppStrings.cancel, controller.cancel),
      ],
    );
  }
}
