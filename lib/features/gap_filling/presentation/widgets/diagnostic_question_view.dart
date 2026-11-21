import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/step_progress.dart';
import '../controllers/diagnostic_controller.dart';
import 'choice_card.dart';
import 'gap_filling_dimens.dart';
import 'gap_filling_strings.dart';

/// One question, no right or wrong feedback.
class DiagnosticQuestionView extends StatelessWidget {
  const DiagnosticQuestionView({super.key, required this.controller});

  final DiagnosticController controller;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Obx(() {
      final plan = controller.currentPlan;
      final question = controller.currentQuestion;
      final selected = controller.selected.value;
      return Padding(
        padding: GapFillingDimens.pagePadding,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(
            child: StepProgress(
              current: controller.questionIndex.value + 1,
              total: plan.questions.length,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            plan.subjectName,
            textAlign: TextAlign.center,
            style: TextStyle(color: c.textSecondary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSizes.lg),
          Expanded(
            child: ListView.builder(
              itemCount: question.choices.length + 1,
              itemBuilder: (context, i) => i == 0
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.lg),
                      child: Text(
                        question.prompt,
                        style: TextStyle(
                          fontSize: GapFillingDimens.questionSize,
                          fontWeight: FontWeight.w700,
                          height: GapFillingDimens.miniLessonLineHeight,
                          color: c.textPrimary,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.md),
                      child: ChoiceCard(
                        label: question.choices[i - 1],
                        state: selected == i - 1 ? ChoiceState.selected : ChoiceState.idle,
                        onTap: () => controller.choose(i - 1),
                      ),
                    ),
            ),
          ),
          SizedBox(
            height: AppSizes.buttonHeight,
            child: PrimaryButton(
              label: GapFillingStrings.next,
              onPressed: selected == null ? null : controller.next,
            ),
          ),
          TextButton(
            onPressed: controller.skip,
            child: Text(GapFillingStrings.dontKnow, style: TextStyle(color: c.textSecondary)),
          ),
        ]),
      );
    });
  }
}
