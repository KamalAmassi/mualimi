import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/state_message.dart';
import '../controllers/skill_review_controller.dart';
import '../widgets/gap_filling_strings.dart';
import '../widgets/review_question_view.dart';
import '../widgets/review_result_view.dart';
import '../widgets/skill_lesson_view.dart';

/// `AppRoutes.skillReview`.
class SkillReviewPage extends GetView<SkillReviewController> {
  const SkillReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(child: Obx(_body)),
    );
  }

  Widget _body() => switch (controller.stage.value) {
        SkillReviewStage.loading => const Center(child: CircularProgressIndicator()),
        SkillReviewStage.lesson => SkillLessonView(
            skill: controller.review.value!.skill,
            onStart: controller.startQuestions,
          ),
        SkillReviewStage.question => ReviewQuestionView(controller: controller),
        SkillReviewStage.result => ReviewResultView(
            stillWeak: controller.outcome.value!.stillWeak,
            fromLesson: controller.opensFromLesson,
            onAgain: controller.reviewAgain,
            onLeave: controller.leave,
          ),
        SkillReviewStage.failed => StateMessage(
            icon: LucideIcons.refreshCw,
            title: GapFillingStrings.loadFailedTitle,
            message: GapFillingStrings.loadFailedMessage,
            actionLabel: GapFillingStrings.back,
            onAction: controller.leave,
          ),
      };
}
