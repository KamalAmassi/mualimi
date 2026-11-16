import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/answer_source.dart';
import 'tutor_sizes.dart';

/// "المصدر: subject · lesson · ص page", tappable to open the book page.
class SourceLine extends StatelessWidget {
  const SourceLine({super.key, required this.source, required this.onOpen});

  final AnswerSource source;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(TutorSizes.smallButtonRadius),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: AppSizes.sm),
        decoration: BoxDecoration(
          color: c.background,
          borderRadius: BorderRadius.circular(TutorSizes.smallButtonRadius),
        ),
        child: Row(children: [
          Icon(LucideIcons.bookOpen, size: AppSizes.lg, color: c.primaryText),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text.rich(
              TextSpan(children: [
                const TextSpan(
                    text: '${AppStrings.sourceLabel}: ',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                TextSpan(
                    text: '${source.subjectName} · ${source.lessonTitle} · '
                        '${AppStrings.pagesPrefix} ${source.printedPage}'),
              ]),
              style: TextStyle(fontSize: 12.5, color: c.textPrimary),
            ),
          ),
        ]),
      ),
    );
  }
}
