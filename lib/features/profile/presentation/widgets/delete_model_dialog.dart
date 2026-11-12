import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../controllers/profile_controller.dart';

Future<void> showDeleteModelDialog(ProfileController controller) {
  return Get.dialog<void>(AlertDialog(
    title: const Text(AppStrings.deleteModelTitle),
    content: const Text(AppStrings.deleteModelMessage),
    actions: [
      TextButton(onPressed: Get.back, child: const Text(AppStrings.cancel)),
      TextButton(
        onPressed: () async {
          await controller.deleteModel();
          Get.back<void>();
        },
        child: const Text(AppStrings.delete),
      ),
    ],
  ));
}
