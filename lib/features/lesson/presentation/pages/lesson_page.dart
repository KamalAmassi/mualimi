import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/lesson_controller.dart';
import '../controllers/viewer_tab.dart';

class LessonPage extends GetView<LessonController> {
  const LessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(controller.lesson.value?.title ?? AppStrings.lesson))),
      body: Obx(() {
        final lesson = controller.lesson.value;
        return ListView(padding: const EdgeInsets.all(AppSizes.pagePadding), children: [
          // TODO(youtube_player_iframe): embed the real player; the offline card is the design's fallback.
          AppCard(
            child: Text(controller.videoAvailable
                ? (lesson?.videoUrl ?? AppStrings.videoMissing)
                : AppStrings.videoNeedsInternet),
          ),
          const SizedBox(height: AppSizes.md),
          if (lesson != null)
            for (var i = 0; i < lesson.sections.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: AppCard(
                  onTap: () => controller.selectSection(i),
                  child: Text(lesson.sections[i].title),
                ),
              ),
          const SizedBox(height: AppSizes.md),
          PrimaryButton(
            label: AppStrings.viewer,
            onPressed: () => controller.openViewer(ViewerTab.explanation),
            outlined: true,
          ),
          const SizedBox(height: AppSizes.sm),
          PrimaryButton(label: AppStrings.keyTerms, onPressed: controller.openKeyTerms, outlined: true),
          const SizedBox(height: AppSizes.sm),
          PrimaryButton(
            label: AppStrings.askTutor,
            onPressed: lesson?.tutorEnabled == true ? controller.askTutor : null,
          ),
        ]);
      }),
    );
  }
}
