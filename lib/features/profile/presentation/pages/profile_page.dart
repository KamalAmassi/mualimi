import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../content_manager/presentation/widgets/model_download_card.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../controllers/profile_controller.dart';
import '../widgets/change_grade_sheet.dart';
import '../widgets/delete_model_dialog.dart';
import '../widgets/edit_name_sheet.dart';

/// Shell tab 3.
class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: Obx(() {
        final p = controller.profile.value;
        return ListView(padding: const EdgeInsets.all(AppSizes.pagePadding), children: [
          AppCard(child: Text('${p.name} · ${AppStrings.gradePrefix} ${p.grade ?? '-'}')),
          const SizedBox(height: AppSizes.md),
          PrimaryButton(
            label: AppStrings.editName,
            onPressed: () => showEditNameSheet(controller),
            outlined: true,
          ),
          const SizedBox(height: AppSizes.sm),
          PrimaryButton(
            label: AppStrings.changeGrade,
            onPressed: () => showChangeGradeSheet(controller),
            outlined: true,
          ),
          const SizedBox(height: AppSizes.sm),
          PrimaryButton(
            label: AppStrings.toggleTheme,
            onPressed: () => controller.setTheme(
                p.themeMode == AppThemeMode.dark ? AppThemeMode.light : AppThemeMode.dark),
            outlined: true,
          ),
          const SizedBox(height: AppSizes.lg),
          const ModelDownloadCard(),
          const SizedBox(height: AppSizes.sm),
          PrimaryButton(
            label: AppStrings.deleteModelTitle,
            onPressed: () => showDeleteModelDialog(controller),
            outlined: true,
          ),
        ]);
      }),
    );
  }
}
