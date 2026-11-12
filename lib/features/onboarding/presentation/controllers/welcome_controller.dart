import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../domain/usecases/save_student_name_usecase.dart';

class WelcomeController extends GetxController {
  WelcomeController(this._saveName);
  final SaveStudentNameUseCase _saveName;

  final nameField = TextEditingController();
  final invalid = false.obs;

  Future<void> next() async {
    final saved = await _saveName(nameField.text);
    invalid.value = !saved;
    if (saved) Get.toNamed<void>(AppRoutes.grade);
  }

  @override
  void onClose() {
    nameField.dispose();
    super.onClose();
  }
}
