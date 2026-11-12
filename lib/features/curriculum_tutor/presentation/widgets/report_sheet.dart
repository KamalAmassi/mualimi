import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/chat_message.dart';
import '../controllers/report_controller.dart';

Future<void> showReportSheet(ChatMessage message, {String? lessonId}) {
  final controller = Get.find<ReportController>()..reset();
  return showAppBottomSheet<void>(
    ReportSheet(controller: controller, message: message, lessonId: lessonId),
  );
}

class ReportSheet extends StatelessWidget {
  const ReportSheet({
    super.key,
    required this.controller,
    required this.message,
    this.lessonId,
  });

  final ReportController controller;
  final ChatMessage message;
  final String? lessonId;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(AppStrings.reportAnswer, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 12),
      Obx(() => Wrap(spacing: 8, children: [
            for (final r in ReportController.reasons)
              AppChip(
                label: r,
                selected: controller.reason.value == r,
                onTap: () => controller.reason.value = r,
              ),
          ])),
      const SizedBox(height: 12),
      TextField(
        controller: controller.note,
        decoration: const InputDecoration(hintText: AppStrings.reportNoteHint),
      ),
      const SizedBox(height: 12),
      PrimaryButton(
        label: AppStrings.send,
        onPressed: () => controller.submit(message, lessonId: lessonId),
      ),
    ]);
  }
}
