import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/state_message.dart';
import '../controllers/saved_controller.dart';

class SavedPage extends GetView<SavedController> {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.saved)),
      body: Obx(() {
        final history = controller.showHistory.value;
        final empty = history ? controller.history.isEmpty : controller.saved.isEmpty;
        return Column(children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Row(children: [
              AppChip(
                label: AppStrings.saved,
                selected: !history,
                onTap: () => controller.selectTab(history: false),
              ),
              const SizedBox(width: AppSizes.sm),
              AppChip(
                label: AppStrings.questionHistory,
                selected: history,
                onTap: () => controller.selectTab(history: true),
              ),
            ]),
          ),
          Expanded(
            child: empty
                ? const StateMessage(icon: Icons.bookmark_border, title: AppStrings.savedEmpty)
                : ListView(padding: const EdgeInsets.all(AppSizes.lg), children: [
                    if (history)
                      for (final h in controller.history)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSizes.sm),
                          child: AppCard(child: Text(h.question)),
                        )
                    else
                      for (final s in controller.saved)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSizes.sm),
                          child: AppCard(
                            onTap: () => controller.remove(s),
                            child: Text('${s.question}\n${s.answer}'),
                          ),
                        ),
                  ]),
          ),
        ]);
      }),
    );
  }
}
