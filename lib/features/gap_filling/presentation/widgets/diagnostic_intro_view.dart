import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/subject_diagnostic.dart';
import 'gap_filling_dimens.dart';
import 'gap_filling_strings.dart';

class DiagnosticIntroView extends StatelessWidget {
  const DiagnosticIntroView({
    super.key,
    required this.plans,
    required this.onStart,
    required this.onLater,
  });

  final List<SubjectDiagnostic> plans;
  final VoidCallback onStart;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: GapFillingDimens.pagePadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: ListView.builder(
            itemCount: plans.length + 1,
            itemBuilder: (context, i) => i == 0
                ? _Header(subjectsLabel: GapFillingStrings.introSubjects)
                : Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.sm),
                    child: _SubjectRow(plan: plans[i - 1]),
                  ),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        SizedBox(
          height: AppSizes.buttonHeight,
          child: PrimaryButton(label: GapFillingStrings.start, onPressed: onStart),
        ),
        TextButton(
          onPressed: onLater,
          child: Text(GapFillingStrings.later, style: TextStyle(color: c.textSecondary)),
        ),
      ]),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.subjectsLabel});

  final String subjectsLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: AppSizes.xxl),
      Icon(LucideIcons.compass, size: GapFillingDimens.heroIconSize, color: c.primary),
      const SizedBox(height: AppSizes.lg),
      Text(
        GapFillingStrings.introTitle,
        style: TextStyle(
          fontSize: GapFillingDimens.titleSize,
          fontWeight: FontWeight.w800,
          color: c.textPrimary,
        ),
      ),
      const SizedBox(height: AppSizes.md),
      Text(
        GapFillingStrings.introBody,
        style: TextStyle(
          fontSize: GapFillingDimens.bodySize,
          height: GapFillingDimens.miniLessonLineHeight,
          color: c.textBody,
        ),
      ),
      const SizedBox(height: AppSizes.xxl),
      Text(
        subjectsLabel,
        style: TextStyle(fontWeight: FontWeight.w700, color: c.textSecondary),
      ),
      const SizedBox(height: AppSizes.sm),
    ]);
  }
}

class _SubjectRow extends StatelessWidget {
  const _SubjectRow({required this.plan});

  final SubjectDiagnostic plan;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(children: [
        Expanded(
          child: Text(
            plan.subjectName,
            style: TextStyle(
              fontSize: GapFillingDimens.bodySize,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ),
        Text(
          GapFillingStrings.minutes(plan.estimatedMinutes),
          style: TextStyle(color: c.textSecondary),
        ),
      ]),
    );
  }
}
