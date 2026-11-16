import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/tutor_page.dart';

/// The tutor as a full screen on top of the current page, with a back button.
class TutorRoutePage extends StatelessWidget {
  const TutorRoutePage({super.key});

  @override
  Widget build(BuildContext context) => TutorPage(onBack: Get.back<void>);
}
