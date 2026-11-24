import 'package:flutter/widgets.dart';

import '../../domain/entities/section_inline.dart';
import 'section_body_dimens.dart';
import 'section_rich_text.dart';

class SectionBulletList extends StatelessWidget {
  const SectionBulletList({super.key, required this.items, required this.style});

  final List<List<SectionInline>> items;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in items)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: SectionBodyDimens.bulletIndent,
              child: Text(SectionBodyDimens.bulletGlyph, style: style),
            ),
            Expanded(child: SectionRichText(inlines: item, style: style)),
          ]),
      ],
    );
  }
}
