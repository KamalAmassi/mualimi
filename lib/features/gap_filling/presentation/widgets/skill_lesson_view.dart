import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/skill.dart';
import 'gap_filling_dimens.dart';
import 'gap_filling_strings.dart';
import 'mini_lesson_view.dart';

/// The reading step of a mini review.
class SkillLessonView extends StatelessWidget {
  const SkillLessonView({super.key, required this.skill, required this.onStart});

  final Skill skill;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: GapFillingDimens.pagePadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                skill.title,
                style: TextStyle(
                  fontSize: GapFillingDimens.titleSize,
                  fontWeight: FontWeight.w800,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                GapFillingStrings.fromGrade(skill.grade),
                style: TextStyle(color: c.textSecondary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSizes.md),
              Text(GapFillingStrings.reviewIntro, style: TextStyle(color: c.textSecondary)),
              const SizedBox(height: AppSizes.lg),
              MiniLessonView(markdown: skill.miniLesson),
            ]),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        SizedBox(
          height: AppSizes.buttonHeight,
          child: PrimaryButton(label: GapFillingStrings.startQuestions, onPressed: onStart),
        ),
      ]),
    );
  }
}
