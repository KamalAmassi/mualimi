import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/state_message.dart';
import '../controllers/subject_controller.dart';
import '../widgets/subject_dimens.dart';
import '../widgets/subject_header.dart';
import '../widgets/subject_strings.dart';
import '../widgets/subject_unit_card.dart';

/// Units of one subject, each expanding into its lessons.
class SubjectPage extends GetView<SubjectController> {
  const SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Obx(() {
        final subject = controller.subject.value;
        final loaded = controller.loaded.value;
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SubjectHeader(
            subjectId: controller.subjectId,
            title: subject?.name ?? AppStrings.subject,
            subtitle: loaded ? controller.headerSubtitle : null,
            onBack: Get.back<void>,
            onAskTutor: controller.canAskTutor ? controller.askTutor : null,
          ),
          Expanded(child: _body()),
        ]);
      }),
    );
  }

  Widget _body() {
    if (controller.failure.value != null) {
      return StateMessage(
        icon: LucideIcons.triangleAlert,
        title: SubjectStrings.failureTitle,
        actionLabel: AppStrings.retry,
        onAction: controller.load,
      );
    }
    if (controller.isEmpty) {
      return const StateMessage(icon: LucideIcons.bookOpen, title: SubjectStrings.emptyTitle);
    }
    final units = controller.units.toList();
    final expanded = controller.expanded.toSet();
    final lastOpened = controller.lastOpenedLessonId.value;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
          horizontal: SubjectDimens.listPaddingH, vertical: SubjectDimens.listPaddingV),
      itemCount: units.length,
      separatorBuilder: (_, __) => const SizedBox(height: SubjectDimens.listGap),
      itemBuilder: (context, index) {
        final unit = units[index];
        return SubjectUnitCard(
          unit: unit,
          expanded: expanded.contains(unit.id),
          lastOpenedLessonId: lastOpened,
          onToggle: () => controller.toggle(unit.id),
          onOpenLesson: controller.openLesson,
        );
      },
    );
  }
}
