import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/byte_formatter.dart';
import '../../../../core/widgets/placeholder_page.dart';
import '../controllers/pack_download_controller.dart';

class DownloadNoSpacePage extends StatelessWidget {
  const DownloadNoSpacePage({super.key, required this.controller});

  final PackDownloadController controller;

  @override
  Widget build(BuildContext context) {
    final f = controller.failure.value;
    final detail = f is NotEnoughSpaceFailure
        ? '${ByteFormatter.format(f.freeBytes)} / ${ByteFormatter.format(f.requiredBytes)}'
        : null;
    return PlaceholderPage(
      title: AppStrings.downloadNoSpace,
      status: detail,
      actions: [PlaceholderAction(AppStrings.retry, controller.start)],
    );
  }
}
