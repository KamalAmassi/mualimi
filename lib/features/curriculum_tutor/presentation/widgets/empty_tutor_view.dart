import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'tutor_sizes.dart';

/// First screen of a new chat: what the tutor does and three questions to try.
class EmptyTutorView extends StatelessWidget {
  const EmptyTutorView({
    super.key,
    required this.subjectName,
    required this.examples,
    required this.onExample,
  });

  final String subjectName;
  final List<String> examples;
  final ValueChanged<String> onExample;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ListView(
      padding:
          const EdgeInsets.symmetric(vertical: 22, horizontal: AppSizes.lg),
      children: [
        Center(
          child: Container(
            width: TutorSizes.emptyIcon,
            height: TutorSizes.emptyIcon,
            decoration: BoxDecoration(
              color: c.tint,
              borderRadius: BorderRadius.circular(TutorSizes.emptyIconRadius),
            ),
            child: Icon(LucideIcons.sparkles,
                size: AppSizes.iconLg - 8, color: c.primary),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Text('${AppStrings.askAboutAnyLessonIn} $subjectName',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: c.textPrimary)),
        const SizedBox(height: AppSizes.md),
        Text(AppStrings.emptySubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.5, height: 1.75, color: c.textSecondary)),
        const SizedBox(height: AppSizes.xxl),
        Text(AppStrings.tryExample,
            style: TextStyle(
                fontSize: TutorSizes.textChip,
                fontWeight: FontWeight.w600,
                color: c.textSecondary)),
        const SizedBox(height: AppSizes.sm),
        for (final example in examples)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: _ExampleTile(text: example, onTap: () => onExample(example)),
          ),
      ],
    );
  }
}

class _ExampleTile extends StatelessWidget {
  const _ExampleTile({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(TutorSizes.exampleRadius);
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
          borderRadius: radius, side: BorderSide(color: c.outline)),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          constraints:
              const BoxConstraints(minHeight: TutorSizes.exampleHeight),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(children: [
            Icon(LucideIcons.search, size: AppSizes.xl - 2, color: c.primary),
            const SizedBox(width: 10),
            Expanded(
                child: Text(text,
                    style: TextStyle(fontSize: 14, color: c.textPrimary))),
            Icon(LucideIcons.chevronLeft,
                size: AppSizes.xl - 2, color: c.textSecondary),
          ]),
        ),
      ),
    );
  }
}
