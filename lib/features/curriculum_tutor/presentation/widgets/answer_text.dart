import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../formatting/answer_text_parser.dart';
import 'tutor_sizes.dart';

/// An answer's text with numbered points shown as badges.
class AnswerText extends StatelessWidget {
  const AnswerText({super.key, required this.text, this.cursor = false});

  final String text;

  /// Shows a caret after the text while the answer is still streaming.
  final bool cursor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = TextStyle(
      fontSize: TutorSizes.textBody,
      height: TutorSizes.lineHeightBody,
      color: c.textPrimary,
    );
    final blocks = AnswerTextParser.parse(text);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (var i = 0; i < blocks.length; i++)
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : AppSizes.sm),
          child: _Block(
            block: blocks[i],
            style: style,
            cursor: cursor && i == blocks.length - 1,
          ),
        ),
    ]);
  }
}

class _Block extends StatelessWidget {
  const _Block(
      {required this.block, required this.style, required this.cursor});

  final AnswerBlock block;
  final TextStyle style;
  final bool cursor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Text.rich(
        TextSpan(children: [
          for (final run in block.runs)
            TextSpan(
              text: run.text,
              style: run.bold
                  ? const TextStyle(fontWeight: FontWeight.w700)
                  : null,
            ),
          if (cursor)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                width: AppSizes.sm,
                height: 17,
                margin: const EdgeInsetsDirectional.only(start: 3),
                decoration: BoxDecoration(
                  color: c.primaryText,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ]),
        style: style);
    final number = block.number;
    if (number == null) return text;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: TutorSizes.stepBadge,
        height: TutorSizes.stepBadge,
        margin: const EdgeInsetsDirectional.only(end: 10, top: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: c.tint,
          borderRadius: BorderRadius.circular(TutorSizes.stepBadgeRadius),
        ),
        child: Text(number,
            style: TextStyle(
                fontSize: TutorSizes.textChip,
                fontWeight: FontWeight.w700,
                color: c.primary)),
      ),
      Expanded(child: text),
    ]);
  }
}
