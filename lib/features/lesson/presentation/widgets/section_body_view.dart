import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/section_block.dart';
import 'section_body_dimens.dart';
import 'section_bullet_list.dart';
import 'section_callout.dart';
import 'section_display_math.dart';
import 'section_image.dart';
import 'section_rich_text.dart';
import 'section_table.dart';
import 'viewer_dimens.dart';

/// The blocks of one section body, top to bottom. Every font size is
/// multiplied by [fontScale]; the device text scale applies on top.
class SectionBodyView extends StatelessWidget {
  const SectionBodyView({
    super.key,
    required this.blocks,
    required this.fontScale,
    required this.imagePathOf,
  });

  final List<SectionBlock> blocks;
  final double fontScale;
  final String? Function(String relativePath) imagePathOf;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final body = TextStyle(
      fontSize: ViewerDimens.bodySize * fontScale,
      height: ViewerDimens.bodyLineHeight,
      color: c.textPrimary,
    );
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final (index, block) in blocks.indexed) ...[
        if (index > 0) SizedBox(height: _gapBefore(block)),
        _block(block, body, c),
      ],
    ]);
  }

  double _gapBefore(SectionBlock block) => block is HeadingBlock && block.level == 2
      ? ViewerDimens.articleGap + SectionBodyDimens.heading2TopGap
      : ViewerDimens.articleGap;

  Widget _block(SectionBlock block, TextStyle body, AppColors c) => switch (block) {
        HeadingBlock(:final level, :final inlines) => SectionRichText(
            inlines: inlines,
            style: TextStyle(
              fontSize: (level == 2 ? ViewerDimens.headingSize : SectionBodyDimens.heading3Size) *
                  fontScale,
              fontWeight: FontWeight.w700,
              color: level == 2 ? c.primary : c.textPrimary,
            ),
          ),
        ParagraphBlock(:final inlines) => SectionRichText(inlines: inlines, style: body),
        BulletListBlock(:final items) => SectionBulletList(items: items, style: body),
        CalloutBlock(:final kind, :final inlines) =>
          SectionCallout(kind: kind, inlines: inlines, fontScale: fontScale),
        DisplayMathBlock(:final tex) => SectionDisplayMath(tex: tex, fontScale: fontScale),
        ImageBlock(:final caption, :final path) =>
          SectionImage(path: imagePathOf(path), caption: caption, fontScale: fontScale),
        TableBlock(:final header, :final rows) =>
          SectionTable(header: header, rows: rows, fontScale: fontScale),
      };
}
