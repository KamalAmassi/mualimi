import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/section_inline.dart';
import 'section_body_dimens.dart';
import 'section_rich_text.dart';

/// A table whose columns wrap past a maximum width and which scrolls sideways
/// when it is still wider than the page.
class SectionTable extends StatelessWidget {
  const SectionTable({
    super.key,
    required this.header,
    required this.rows,
    required this.fontScale,
  });

  final List<List<SectionInline>> header;
  final List<List<List<SectionInline>>> rows;
  final double fontScale;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = TextStyle(
      fontSize: SectionBodyDimens.tableTextSize * fontScale,
      height: SectionBodyDimens.tableLineHeight,
      color: c.textPrimary,
    );
    final headerStyle = style.copyWith(fontWeight: FontWeight.w700);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: MinColumnWidth(
          const IntrinsicColumnWidth(),
          FixedColumnWidth(SectionBodyDimens.tableMaxColumnWidth * fontScale),
        ),
        border: TableBorder.all(
          color: c.outline,
          width: SectionBodyDimens.tableBorderWidth,
          borderRadius: BorderRadius.circular(SectionBodyDimens.tableRadius),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: c.surfaceVariant,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(SectionBodyDimens.tableRadius),
              ),
            ),
            children: [for (final cell in header) _cell(cell, headerStyle)],
          ),
          for (final row in rows) TableRow(children: [for (final cell in row) _cell(cell, style)]),
        ],
      ),
    );
  }

  Widget _cell(List<SectionInline> inlines, TextStyle style) => Padding(
        padding: SectionBodyDimens.tableCellPadding,
        child: SectionRichText(inlines: inlines, style: style),
      );
}
