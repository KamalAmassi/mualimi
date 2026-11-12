import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_card.dart';
import '../controllers/key_terms_controller.dart';

class KeyTermsPage extends GetView<KeyTermsController> {
  const KeyTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.keyTerms)),
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            children: [
              for (final t in controller.terms)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: AppCard(child: Text('${t.term}: ${t.definition}')),
                ),
            ],
          )),
    );
  }
}
