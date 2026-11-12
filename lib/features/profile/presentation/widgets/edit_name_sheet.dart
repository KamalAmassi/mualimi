import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/profile_controller.dart';

Future<void> showEditNameSheet(ProfileController controller) =>
    showAppBottomSheet<void>(EditNameSheet(controller: controller));

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
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Obx(() => TextField(
            controller: _field,
            decoration: InputDecoration(
              hintText: AppStrings.studentNameHint,
              errorText: widget.controller.nameInvalid.value ? AppStrings.studentNameInvalid : null,
            ),
          )),
      const SizedBox(height: 16),
      PrimaryButton(label: AppStrings.save, onPressed: _save),
    ]);
  }
}
