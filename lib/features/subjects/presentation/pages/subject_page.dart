import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_card.dart';
import '../controllers/subject_controller.dart';

class SubjectPage extends GetView<SubjectController> {
  const SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(controller.subject.value?.name ?? AppStrings.subject))),
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            children: [
              for (final unit in controller.units) ...[
                ListTile(
                  title: Text(unit.title),
                  trailing: Icon(controller.expanded.contains(unit.id)
                      ? Icons.expand_less
                      : Icons.expand_more),
                  onTap: () => controller.toggle(unit.id),
                ),
                if (controller.expanded.contains(unit.id))
                  for (final lesson in unit.lessons)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.sm),
                      child: AppCard(
                        onTap: () => controller.openLesson(lesson),
                        child: Text(lesson.title),
                      ),
                    ),
              ],
            ],
          )),
    );
  }
}
