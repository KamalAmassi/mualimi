import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_chip.dart';
import '../controllers/profile_controller.dart';

Future<void> showChangeGradeSheet(ProfileController controller) =>
    showAppBottomSheet<void>(ChangeGradeSheet(controller: controller));

class ChangeGradeSheet extends StatelessWidget {
  const ChangeGradeSheet({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, children: [
      for (final g in AppConfig.availableGrades)
        AppChip(
          label: '${AppStrings.gradePrefix} $g',
          selected: controller.current.grade == g,
          onTap: () {
            Get.back<void>();
            controller.changeGrade(g);
          },
        ),
    ]);
  }
}
