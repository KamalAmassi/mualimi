import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/step_progress.dart';
import '../controllers/grade_controller.dart';

class GradePage extends GetView<GradeController> {
  const GradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.grade)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Center(child: StepProgress(current: 2, total: 3)),
          const SizedBox(height: AppSizes.xl),
          Obx(() => Wrap(spacing: AppSizes.sm, children: [
                for (final g in controller.availableGrades)
                  AppChip(
                    label: '${AppStrings.gradePrefix} $g',
                    selected: controller.selected.value == g,
                    onTap: () => controller.select(g),
                  ),
              ])),
          const SizedBox(height: AppSizes.xl),
          Obx(() => PrimaryButton(
                label: AppStrings.next,
                onPressed: controller.selected.value == null ? null : controller.next,
              )),
        ]),
      ),
    );
  }
}
