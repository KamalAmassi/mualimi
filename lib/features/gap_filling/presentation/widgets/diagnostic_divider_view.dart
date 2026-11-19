import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/primary_button.dart';
import 'gap_filling_dimens.dart';
import 'gap_filling_strings.dart';

/// Shown between two subjects.
class DiagnosticDividerView extends StatelessWidget {
  const DiagnosticDividerView({super.key, required this.subjectName, required this.onContinue});

  final String subjectName;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: GapFillingDimens.pagePadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(LucideIcons.bookOpen, size: GapFillingDimens.heroIconSize, color: c.primary),
            const SizedBox(height: AppSizes.lg),
            Text(GapFillingStrings.dividerLead, style: TextStyle(color: c.textSecondary)),
            const SizedBox(height: AppSizes.sm),
            Text(
              subjectName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: GapFillingDimens.titleSize,
                fontWeight: FontWeight.w800,
                color: c.textPrimary,
              ),
            ),
          ]),
        ),
        SizedBox(
          height: AppSizes.buttonHeight,
          child: PrimaryButton(label: GapFillingStrings.dividerContinue, onPressed: onContinue),
        ),
      ]),
    );
  }
}
