import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../controllers/profile_controller.dart';
import 'profile_sheet_button.dart';
import 'profile_sheet_dimens.dart';
import 'profile_sheet_header.dart';
import 'profile_sheet_strings.dart';
import 'profile_strings.dart';

Future<void> showEditNameSheet(ProfileController controller) {
  controller.nameInvalid.value = false;
  return showAppBottomSheet<void>(EditNameSheet(controller: controller));
}

class EditNameSheet extends StatefulWidget {
  const EditNameSheet({super.key, required this.controller});

  final ProfileController controller;

  @override
  State<EditNameSheet> createState() => _EditNameSheetState();
}

class _EditNameSheetState extends State<EditNameSheet> {
  late final TextEditingController _field =
      TextEditingController(text: widget.controller.current.name);

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (await widget.controller.saveName(_field.text)) Get.back<void>();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(ProfileSheetDimens.fieldRadius),
          borderSide: BorderSide(color: color, width: ProfileSheetDimens.fieldBorder),
        );
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: ProfileSheetDimens.blockGap,
          children: [
            const ProfileSheetHeader(title: ProfileStrings.editName),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: ProfileSheetDimens.fieldGap,
              children: [
                Text(ProfileSheetStrings.yourName,
                    style: TextStyle(
                        fontSize: ProfileSheetDimens.labelFontSize,
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary)),
                Obx(() => TextField(
                      controller: _field,
                      onSubmitted: (_) => _save(),
                      style: TextStyle(
                          fontSize: ProfileSheetDimens.fieldFontSize, color: c.textPrimary),
                      decoration: InputDecoration(
                        hintText: AppStrings.studentNameHint,
                        errorText: widget.controller.nameInvalid.value
                            ? AppStrings.studentNameInvalid
                            : null,
                        filled: true,
                        fillColor: c.surface,
                        constraints:
                            const BoxConstraints(minHeight: ProfileSheetDimens.fieldHeight),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: ProfileSheetDimens.fieldPaddingH),
                        enabledBorder: border(c.primary),
                        focusedBorder: border(c.primary),
                        errorBorder: border(c.error),
                        focusedErrorBorder: border(c.error),
                      ),
                    )),
                Text(ProfileSheetStrings.nameNote,
                    style: TextStyle(
                        fontSize: ProfileSheetDimens.fieldNoteFontSize, color: c.textSecondary)),
              ],
            ),
            ProfileSheetButton(label: AppStrings.save, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
