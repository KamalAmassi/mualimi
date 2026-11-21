import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/state_message.dart';
import '../controllers/diagnostic_controller.dart';
import '../controllers/diagnostic_stage.dart';
import '../widgets/diagnostic_divider_view.dart';
import '../widgets/diagnostic_intro_view.dart';
import '../widgets/diagnostic_question_view.dart';
import '../widgets/diagnostic_result_view.dart';
import '../widgets/gap_filling_strings.dart';

/// `AppRoutes.diagnostic`.
class DiagnosticPage extends GetView<DiagnosticController> {
  const DiagnosticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
          canPop: !controller.blocksBack,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) controller.leave();
          },
          child: Scaffold(
            backgroundColor: context.colors.background,
            body: SafeArea(child: _body()),
          ),
        ));
  }

  Widget _body() => switch (controller.stage.value) {
        DiagnosticStage.loading => const Center(child: CircularProgressIndicator()),
        DiagnosticStage.intro => DiagnosticIntroView(
            plans: controller.plans.toList(),
            onStart: controller.start,
            onLater: controller.leave,
          ),
        DiagnosticStage.question => DiagnosticQuestionView(controller: controller),
        DiagnosticStage.divider => DiagnosticDividerView(
            subjectName: controller.currentPlan.subjectName,
            onContinue: controller.continueFromDivider,
          ),
        DiagnosticStage.result => DiagnosticResultView(
            results: controller.results.toList(),
            onReview: controller.reviewSkill,
            onDone: controller.leave,
          ),
        DiagnosticStage.failed => StateMessage(
            icon: LucideIcons.refreshCw,
            title: GapFillingStrings.loadFailedTitle,
            message: GapFillingStrings.loadFailedMessage,
            actionLabel: GapFillingStrings.back,
            onAction: controller.leave,
          ),
      };
}
