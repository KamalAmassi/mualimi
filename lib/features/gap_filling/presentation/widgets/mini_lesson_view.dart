import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/mini_lesson_block.dart';
import '../../domain/rules/mini_lesson_parser.dart';
import 'gap_filling_dimens.dart';

/// Renders the mini lesson as plain blocks. Place it inside a scroll view.
class MiniLessonView extends StatelessWidget {
  const MiniLessonView({super.key, required this.markdown});

  final String markdown;

  @override
  Widget build(BuildContext context) {
    final blocks = MiniLessonParser.parse(markdown);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: blocks.length,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.md),
        child: _Block(block: blocks[i]),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.block});

  final MiniLessonBlock block;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final body = TextStyle(
      fontSize: GapFillingDimens.bodySize,
      height: GapFillingDimens.miniLessonLineHeight,
      color: c.textBody,
    );
    return switch (block.kind) {
      MiniLessonBlockKind.heading => Text(
          block.text,
          style: body.copyWith(
            fontSize: GapFillingDimens.miniLessonHeadingSize,
            fontWeight: FontWeight.w700,
            color: c.primary,
          ),
        ),
      MiniLessonBlockKind.paragraph => Text(block.text, style: body),
      MiniLessonBlockKind.bullet => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: GapFillingDimens.bulletDotTop),
              child: Container(
                width: GapFillingDimens.bulletDotSize,
                height: GapFillingDimens.bulletDotSize,
                decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(child: Text(block.text, style: body)),
          ],
        ),
      MiniLessonBlockKind.callout => DecoratedBox(
          decoration: BoxDecoration(
            color: c.infoContainer,
            borderRadius: BorderRadius.circular(AppSizes.radiusButton),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Text(block.text, style: body.copyWith(color: c.onInfoContainer)),
          ),
        ),
    };
  }
}
