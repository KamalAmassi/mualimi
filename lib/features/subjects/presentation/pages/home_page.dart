import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_card.dart';
import '../controllers/home_controller.dart';

/// Shell tab 1.
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.subjects)),
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            children: [
              for (final s in controller.subjects)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.md),
                  child: AppCard(onTap: () => controller.open(s), child: Text(s.name)),
                ),
            ],
          )),
    );
  }
}
