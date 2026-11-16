import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/chat_message.dart';
import '../controllers/report_controller.dart';
import 'reason_row.dart';
import 'sheet_title.dart';
import 'tutor_sizes.dart';

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
    final c = context.colors;
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SheetTitle(AppStrings.reportAnswer),
          const SizedBox(height: AppSizes.lg),
          Text(AppStrings.reportIntro,
              style:
                  TextStyle(fontSize: 14, height: 1.7, color: c.textSecondary)),
          const SizedBox(height: AppSizes.sm),
          Obx(() => Column(children: [
                for (final reason in ReportController.reasons)
                  ReasonRow(
                    label: reason,
                    selected: controller.reason.value == reason,
                    onTap: () => controller.reason.value = reason,
                  ),
              ])),
          const SizedBox(height: AppSizes.lg),
          Text(AppStrings.reportDetails,
              style: TextStyle(
                  fontSize: TutorSizes.textChip,
                  fontWeight: FontWeight.w600,
                  color: c.textSecondary)),
          const SizedBox(height: AppSizes.sm),
          TextField(
            controller: controller.note,
            minLines: 2,
            maxLines: 3,
            decoration:
                const InputDecoration(hintText: AppStrings.reportNoteHint),
          ),
          const SizedBox(height: AppSizes.md),
          Row(children: [
            Icon(LucideIcons.shieldCheck,
                size: AppSizes.md + 2, color: c.textSecondary),
            const SizedBox(width: 6),
            Text(AppStrings.reportStoredNote,
                style: TextStyle(
                    fontSize: TutorSizes.textSmall, color: c.textSecondary)),
          ]),
          const SizedBox(height: AppSizes.lg),
          Obx(() => PrimaryButton(
                label: AppStrings.sendReport,
                icon: LucideIcons.send,
                onPressed: controller.reason.value == null
                    ? null
                    : () => controller.submit(message, lessonId: lessonId),
              )),
        ]);
  }
}
