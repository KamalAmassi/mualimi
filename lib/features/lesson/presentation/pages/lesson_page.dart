import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/state_message.dart';
import '../controllers/lesson_controller.dart';
import '../controllers/viewer_tab.dart';
import '../widgets/lesson_ask_tutor_bar.dart';
import '../widgets/lesson_files_section.dart';
import '../widgets/lesson_hub_dimens.dart';
import '../widgets/lesson_hub_header.dart';
import '../widgets/lesson_key_terms_preview.dart';
import '../widgets/lesson_tutor_unavailable_bar.dart';
import '../widgets/viewer_strings.dart';

class LessonPage extends GetView<LessonController> {
  const LessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Obx(() => Column(children: [
            LessonHubHeader(
              title: controller.lesson.value?.title ?? '',
              subtitle: controller.subtitle,
              onBack: Get.back,
            ),
            Expanded(child: _body()),
          ])),
    );
  }

  Widget _body() {
    final lesson = controller.lesson.value;
    if (lesson == null) {
      if (controller.loading.value) return const SizedBox.shrink();
      return StateMessage(
        icon: Icons.error_outline,
        title: ViewerStrings.loadFailed,
        actionLabel: AppStrings.retry,
        onAction: controller.load,
      );
    }
    final hasSections = lesson.sections.isNotEmpty;
    final sections = [
      if (controller.hasPdf || hasSections)
        LessonFilesSection(
          pages: controller.pageRange,
          sectionCount: lesson.sections.length,
          onOpenPdf: controller.hasPdf ? () => controller.openViewer(ViewerTab.pdf) : null,
          onOpenExplanation:
              hasSections ? () => controller.openViewer(ViewerTab.explanation) : null,
        ),
      if (controller.keyTerms.isNotEmpty)
        LessonKeyTermsPreview(
          terms: controller.keyTerms.toList(),
          onOpen: controller.openKeyTerms,
        ),
    ];
    return Column(children: [
      Expanded(
        child: ListView.separated(
          padding: LessonHubDimens.bodyPadding,
          itemCount: sections.length,
          separatorBuilder: (_, __) => const SizedBox(height: LessonHubDimens.sectionGap),
          itemBuilder: (_, i) => sections[i],
        ),
      ),
      SafeArea(
        top: false,
        child: Padding(
          padding: LessonHubDimens.barMargin,
          child: controller.tutorEnabled.value
              ? LessonAskTutorBar(onTap: controller.askTutor)
              : const LessonTutorUnavailableBar(),
        ),
      ),
    ]);
  }
}
