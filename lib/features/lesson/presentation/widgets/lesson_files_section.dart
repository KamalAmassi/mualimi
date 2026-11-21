import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import 'lesson_file_card.dart';
import 'lesson_hub_dimens.dart';
import 'lesson_hub_section_title.dart';
import 'lesson_hub_strings.dart';

/// The book PDF and the written explanation. A null callback hides its card.
class LessonFilesSection extends StatelessWidget {
  const LessonFilesSection({
    super.key,
    required this.pages,
    required this.sectionCount,
    this.onOpenPdf,
    this.onOpenExplanation,
  });

  final String? pages;
  final int sectionCount;
  final VoidCallback? onOpenPdf;
  final VoidCallback? onOpenExplanation;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const LessonHubSectionTitle(title: LessonHubStrings.filesTitle),
      if (onOpenPdf != null) ...[
        const SizedBox(height: LessonHubDimens.sectionInnerGap),
        LessonFileCard(
          icon: LucideIcons.fileText,
          tileColor: c.errorContainer,
          iconColor: c.error,
          title: LessonHubStrings.pdfTitle,
          meta: LessonHubStrings.join([LessonHubStrings.pdfLabel, pages]),
          onTap: onOpenPdf!,
        ),
      ],
      if (onOpenExplanation != null) ...[
        const SizedBox(height: LessonHubDimens.sectionInnerGap),
        LessonFileCard(
          icon: LucideIcons.text,
          tileColor: c.tint,
          iconColor: c.primary,
          title: LessonHubStrings.explanationTitle,
          meta: LessonHubStrings.join(
              [LessonHubStrings.sectionsCount(sectionCount), LessonHubStrings.readyInApp]),
          onTap: onOpenExplanation!,
          showChevron: true,
        ),
      ],
    ]);
  }
}
