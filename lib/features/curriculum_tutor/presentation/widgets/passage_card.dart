import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/passage.dart';
import 'tutor_sizes.dart';

/// A pack passage shown when the cloud tutor can't answer right now.
class PassageCard extends StatelessWidget {
  const PassageCard({super.key, required this.passage, required this.onOpen});

  final Passage passage;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(color: c.outline),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(LucideIcons.bookOpen, size: AppSizes.lg, color: c.primaryText),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              '${AppStrings.pagesPrefix} ${passage.printedPage} · ${passage.lessonTitle}',
              style: TextStyle(
                  fontSize: TutorSizes.textChip,
                  fontWeight: FontWeight.w700,
                  color: c.primaryText),
            ),
          ),
        ]),
        const SizedBox(height: AppSizes.sm),
        Text(passage.text,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: TutorSizes.textBody,
                height: TutorSizes.lineHeightBody,
                color: c.textPrimary)),
        const SizedBox(height: AppSizes.md),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: InkWell(
            onTap: onOpen,
            child: Text(AppStrings.openInPack,
                style: TextStyle(
                    fontSize: TutorSizes.textChip,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    color: c.primaryText)),
          ),
        ),
      ]),
    );
  }
}
