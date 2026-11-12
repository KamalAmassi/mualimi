import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/step_progress.dart';
import '../controllers/welcome_controller.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.welcome)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Center(child: StepProgress(current: 1, total: 3)),
          const SizedBox(height: AppSizes.xl),
          Obx(() => TextField(
                controller: controller.nameField,
                decoration: InputDecoration(
                  hintText: AppStrings.studentNameHint,
                  errorText: controller.invalid.value ? AppStrings.studentNameInvalid : null,
                ),
              )),
          const SizedBox(height: AppSizes.xl),
          PrimaryButton(label: AppStrings.next, onPressed: controller.next),
        ]),
      ),
    );
  }
}
