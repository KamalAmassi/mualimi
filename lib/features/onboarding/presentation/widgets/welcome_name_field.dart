import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/welcome_controller.dart';
import 'welcome_dimens.dart';
import 'welcome_strings.dart';

/// Name question, its text field and the on-device privacy note.
class WelcomeNameField extends GetView<WelcomeController> {
  const WelcomeNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(AppSizes.radiusButton);
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: color, width: WelcomeDimens.nameBorder),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.sm,
      children: [
        Text(
          WelcomeStrings.nameLabel,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: WelcomeDimens.nameLabelFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        Obx(() => TextField(
              controller: controller.nameField,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => controller.next(),
              style: TextStyle(color: colors.textPrimary, fontSize: WelcomeDimens.nameFontSize),
              decoration: InputDecoration(
                hintText: AppStrings.studentNameHint,
                errorText: controller.invalid.value ? AppStrings.studentNameInvalid : null,
                enabledBorder: border(colors.outline),
                focusedBorder: border(colors.primaryText),
                errorBorder: border(colors.error),
                focusedErrorBorder: border(colors.error),
              ),
            )),
        Text(
          WelcomeStrings.privacyNote,
          style: TextStyle(color: colors.textSecondary, fontSize: WelcomeDimens.noteFontSize),
        ),
      ],
    );
  }
}
