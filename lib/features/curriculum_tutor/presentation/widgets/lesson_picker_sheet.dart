import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/lesson_picker_controller.dart';
import 'reason_row.dart';
import 'sheet_title.dart';
import 'subject_grid.dart';

Future<void> showLessonPickerSheet() {
  final controller = Get.find<LessonPickerController>()..load();
  return showAppBottomSheet<void>(LessonPickerSheet(controller: controller));
}

class LessonPickerSheet extends StatelessWidget {
  const LessonPickerSheet({super.key, required this.controller});

  final LessonPickerController controller;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.75),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetTitle(AppStrings.chooseSubjectAndLesson),
            const SizedBox(height: AppSizes.lg),
            Obx(() => SubjectGrid(
                  subjects: controller.subjects.toList(),
                  selectedId: controller.selectedSubject.value?.id,
                  onPick: controller.pickSubject,
                )),
            const SizedBox(height: AppSizes.lg),
            Flexible(child: Obx(() => _LessonList(controller: controller))),
            const SizedBox(height: AppSizes.lg),
            PrimaryButton(
                label: AppStrings.done, onPressed: controller.confirm),
          ]),
    );
  }
}

class _LessonList extends StatelessWidget {
  const _LessonList({required this.controller});

  final LessonPickerController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.selectedSubject.value == null) {
      return const SizedBox.shrink();
    }
    final lessons = [for (final unit in controller.units) ...unit.lessons];
    final selected = controller.selectedLessonId.value;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: lessons.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return ReasonRow(
            label: AppStrings.wholeSubject,
            selected: selected == null,
            onTap: controller.pickWholeSubject,
          );
        }
        final lesson = lessons[i - 1];
        return ReasonRow(
          label: lesson.title,
          selected: selected == lesson.id,
          onTap: () => controller.pickLesson(lesson),
        );
      },
    );
  }
}
