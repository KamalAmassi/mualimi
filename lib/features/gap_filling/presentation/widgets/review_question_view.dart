import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/step_progress.dart';
import '../controllers/skill_review_controller.dart';
import 'choice_card.dart';
import 'gap_filling_dimens.dart';
import 'gap_filling_strings.dart';

/// A review question with gentle feedback right after the answer.
class ReviewQuestionView extends StatelessWidget {
  const ReviewQuestionView({super.key, required this.controller});

  final SkillReviewController controller;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Obx(() {
      final question = controller.question;
      final picked = controller.picked.value;
      return Padding(
        padding: GapFillingDimens.pagePadding,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(
            child: StepProgress(
              current: controller.questionIndex.value + 1,
              total: controller.review.value!.questions.length,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Expanded(
            child: ListView.builder(
              itemCount: question.choices.length + 2,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Padding(
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
                  );
                }
                if (i == question.choices.length + 1) {
                  return picked == null
                      ? const SizedBox.shrink()
                      : _Feedback(correct: question.isCorrect(picked), explanation: question.explanation);
                }
                final index = i - 1;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.md),
                  child: ChoiceCard(
                    label: question.choices[index],
                    state: _stateOf(index, picked, question.answerIndex),
                    onTap: picked == null ? () => controller.answer(index) : null,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: AppSizes.buttonHeight,
            child: PrimaryButton(
              label: controller.isLastQuestion
                  ? GapFillingStrings.seeResult
                  : GapFillingStrings.next,
              onPressed: picked == null ? null : controller.next,
            ),
          ),
        ]),
      );
    });
  }

  ChoiceState _stateOf(int index, int? picked, int answer) {
    if (picked == null) return ChoiceState.idle;
    if (index == answer) return ChoiceState.correct;
    return index == picked ? ChoiceState.gentle : ChoiceState.idle;
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({required this.correct, required this.explanation});

  final bool correct;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = correct ? GapFillingStrings.correct : explanation;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: correct ? c.successContainer : c.infoContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusButton),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(
            correct ? LucideIcons.partyPopper : LucideIcons.lightbulb,
            size: AppSizes.iconMd,
            color: correct ? c.onSuccessContainer : c.onInfoContainer,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: GapFillingDimens.bodySize,
                height: GapFillingDimens.miniLessonLineHeight,
                color: correct ? c.onSuccessContainer : c.onInfoContainer,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
