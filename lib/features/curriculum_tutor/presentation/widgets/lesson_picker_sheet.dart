import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/lesson_picker_controller.dart';

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
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
      child: Obx(() => ListView(shrinkWrap: true, children: [
            Text(AppStrings.chooseLesson, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              for (final s in controller.subjects)
                AppChip(
                  label: s.name,
                  selected: controller.selectedSubject.value?.id == s.id,
                  onTap: () => controller.pickSubject(s),
                ),
            ]),
            if (controller.selectedSubject.value != null) ...[
              const SizedBox(height: 8),
              PrimaryButton(
                label: controller.selectedSubject.value!.name,
                onPressed: controller.useWholeSubject,
                outlined: true,
              ),
            ],
            for (final unit in controller.units) ...[
              ListTile(title: Text(unit.title)),
              for (final lesson in unit.lessons)
                ListTile(
                  title: Text(lesson.title),
                  onTap: () => controller.pickLesson(lesson),
                ),
            ],
          ])),
    );
  }
}
