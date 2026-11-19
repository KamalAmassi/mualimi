import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/skill.dart';
import '../../domain/entities/subject_diagnostic_result.dart';
import 'gap_filling_dimens.dart';
import 'gap_filling_strings.dart';
import 'skill_tile.dart';

class DiagnosticResultView extends StatelessWidget {
  const DiagnosticResultView({
    super.key,
    required this.results,
    required this.onReview,
    required this.onDone,
  });

  final List<SubjectDiagnosticResult> results;
  final ValueChanged<Skill> onReview;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: GapFillingDimens.pagePadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: ListView.builder(
            itemCount: results.length + 1,
            itemBuilder: (context, i) => i == 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
                    child: Text(
                      GapFillingStrings.resultTitle,
                      style: TextStyle(
                        fontSize: GapFillingDimens.titleSize,
                        fontWeight: FontWeight.w800,
                        color: c.textPrimary,
                      ),
                    ),
                  )
                : _SubjectResult(result: results[i - 1], onReview: onReview),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        SizedBox(
          height: AppSizes.buttonHeight,
          child: PrimaryButton(label: GapFillingStrings.startStudy, onPressed: onDone),
        ),
      ]),
    );
  }
}

class _SubjectResult extends StatelessWidget {
  const _SubjectResult({required this.result, required this.onReview});

  final SubjectDiagnosticResult result;
  final ValueChanged<Skill> onReview;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final title = TextStyle(
      fontSize: GapFillingDimens.bodySize,
      fontWeight: FontWeight.w700,
      color: c.textPrimary,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.xl),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(result.subjectName, style: title),
        const SizedBox(height: AppSizes.sm),
        if (result.strongSkillCount > 0)
          Text(GapFillingStrings.strongSkills, style: TextStyle(color: c.success)),
        const SizedBox(height: AppSizes.md),
        if (result.weakSkills.isEmpty)
          Text(GapFillingStrings.nothingToReview, style: TextStyle(color: c.textSecondary))
        else ...[
          Text(GapFillingStrings.pathTitle, style: TextStyle(color: c.textSecondary)),
          const SizedBox(height: AppSizes.sm),
          for (final skill in result.weakSkills)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: SkillTile(
                skill: skill,
                actionLabel: GapFillingStrings.reviewNow,
                onTap: () => onReview(skill),
              ),
            ),
        ],
      ]),
    );
  }
}
