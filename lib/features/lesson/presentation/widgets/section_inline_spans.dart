import 'package:flutter/widgets.dart';

import '../../domain/entities/section_inline.dart';
import 'section_inline_math.dart';

/// Builds the spans of one line; the base style comes from the enclosing text.
abstract final class SectionInlineSpans {
  static InlineSpan of(List<SectionInline> inlines, TextStyle base) => TextSpan(
        children: [
          for (final inline in inlines)
            switch (inline) {
              TextInline(:final text, :final bold) =>
                TextSpan(text: text, style: bold ? _bold : null),
              MathInline(:final tex, :final bold) => WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: SectionInlineMath(
                    tex: tex,
                    style: bold ? base.merge(_bold) : base,
                  ),
                ),
            },
        ],
      );

  static const _bold = TextStyle(fontWeight: FontWeight.w700);
}
