import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../controllers/grade_controller.dart';
import '../widgets/grade_dimens.dart';
import '../widgets/grade_download_button.dart';
import '../widgets/grade_grid.dart';
import '../widgets/grade_header.dart';
import '../widgets/grade_strings.dart';
import '../widgets/onboarding_step_indicator.dart';

class GradePage extends GetView<GradeController> {
  const GradePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GradeHeader(onBack: Get.back),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.pagePadding,
                AppSizes.pagePadding,
                AppSizes.pagePadding,
                AppSizes.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSizes.lg,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: GradeDimens.subtitleGap,
                    children: [
                      Text(
                        controller.title,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: GradeDimens.titleFontSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        GradeStrings.subtitle,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: GradeDimens.subtitleFontSize,
                        ),
                      ),
                    ],
                  ),
                  Obx(() => GradeGrid(
                        isAvailable: controller.isAvailable,
                        selected: controller.selected.value,
                        onSelect: controller.select,
                      )),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.pagePadding,
                0,
                AppSizes.pagePadding,
                AppSizes.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: GradeDimens.footerGap,
                children: [
                  const OnboardingStepIndicator(current: 2, total: 3, label: GradeStrings.step),
                  Obx(() => GradeDownloadButton(
                        label: controller.downloadLabel,
                        onPressed: controller.selected.value == null ? null : controller.next,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
