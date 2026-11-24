import 'package:flutter/widgets.dart';

import '../../domain/entities/section_inline.dart';
import 'section_inline_spans.dart';

/// One line of a section body in [style], with its bold and math runs.
class SectionRichText extends StatelessWidget {
  const SectionRichText({super.key, required this.inlines, required this.style});

  final List<SectionInline> inlines;
  final TextStyle style;

  @override
  Widget build(BuildContext context) =>
      Text.rich(SectionInlineSpans.of(inlines, style), style: style);
}
