import 'package:flutter/material.dart';

import '../../domain/entities/key_term.dart';
import 'lesson_hub_dimens.dart';
import 'lesson_hub_section_title.dart';
import 'lesson_hub_strings.dart';
import 'lesson_key_term_card.dart';

/// «مصطلحات الدرس» with a horizontal strip of term cards; any tap opens the
/// key terms screen.
class LessonKeyTermsPreview extends StatelessWidget {
  const LessonKeyTermsPreview({super.key, required this.terms, required this.onOpen});

  final List<KeyTerm> terms;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final cardHeight = LessonHubDimens.termCardPadding.vertical +
        scaler.scale(LessonHubDimens.termSize) * LessonHubDimens.termLineHeight +
        LessonHubDimens.termDefinitionGap +
        scaler.scale(LessonHubDimens.definitionSize) *
            LessonHubDimens.definitionLineHeight *
            LessonHubDimens.definitionMaxLines +
        LessonHubDimens.termCardSlack;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      LessonHubSectionTitle(
        title: LessonHubStrings.keyTermsTitle,
        count: LessonHubStrings.cardsCount(terms.length),
      ),
      const SizedBox(height: LessonHubDimens.sectionInnerGap),
      SizedBox(
        height: cardHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: terms.length,
          separatorBuilder: (_, __) => const SizedBox(width: LessonHubDimens.termCardGap),
          itemBuilder: (context, i) => LessonKeyTermCard(term: terms[i], onTap: onOpen),
        ),
      ),
    ]);
  }
}
