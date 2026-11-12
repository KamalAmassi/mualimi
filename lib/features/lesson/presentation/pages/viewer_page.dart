import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_chip.dart';
import '../controllers/viewer_controller.dart';
import '../controllers/viewer_tab.dart';

class ViewerPage extends GetView<ViewerController> {
  const ViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.viewer)),
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                for (final t in ViewerTab.values)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: AppSizes.sm),
                    child: AppChip(
                      label: t.label,
                      selected: controller.tab.value == t,
                      onTap: () => controller.select(t),
                    ),
                  ),
              ]),
              const SizedBox(height: AppSizes.lg),
              Expanded(child: _body()),
            ]),
          )),
    );
  }

  // TODO(pdfx): render the book pages for the pdf tab.
  Widget _body() => switch (controller.tab.value) {
        ViewerTab.explanation => ListView(children: [
            for (final s in controller.lesson.value?.sections ?? const []) Text('${s.title}\n${s.body}\n'),
          ]),
        ViewerTab.pdf => Text(controller.lesson.value?.pdfFile ?? ''),
        ViewerTab.solutions => ListView(children: [
            for (final s in controller.solutions) Text('${s.number} (${s.page}): ${s.solution}'),
          ]),
      };
}
