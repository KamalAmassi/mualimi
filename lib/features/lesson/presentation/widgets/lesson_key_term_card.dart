import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/key_term.dart';
import 'lesson_hub_dimens.dart';

/// A term and the start of its definition, as previewed on the lesson hub.
class LessonKeyTermCard extends StatelessWidget {
  const LessonKeyTermCard({super.key, required this.term, required this.onTap});

  final KeyTerm term;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(LessonHubDimens.termCardRadius);
    return SizedBox(
      width: LessonHubDimens.termCardWidth,
      child: Material(
        color: c.tintSoft,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: LessonHubDimens.termCardPadding,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                term.term,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: LessonHubDimens.termSize,
                  height: LessonHubDimens.termLineHeight,
                  fontWeight: FontWeight.w700,
                  color: c.onTint,
                ),
              ),
              const SizedBox(height: LessonHubDimens.termDefinitionGap),
              Text(
                term.definition,
                maxLines: LessonHubDimens.definitionMaxLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: LessonHubDimens.definitionSize,
                  height: LessonHubDimens.definitionLineHeight,
                  color: c.textBody,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
