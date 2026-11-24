import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'section_body_dimens.dart';
import 'section_inline_math.dart';

/// A `$$...$$` formula, centred on its own panel (LessonMath.html).
class SectionDisplayMath extends StatelessWidget {
  const SectionDisplayMath({super.key, required this.tex, required this.fontScale});

  final String tex;
  final double fontScale;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.background,
          borderRadius: BorderRadius.circular(SectionBodyDimens.displayMathRadius),
        ),
        child: Padding(
          padding: SectionBodyDimens.displayMathPadding,
          child: SectionInlineMath(
            tex: tex,
            display: true,
            style: TextStyle(
              fontSize: SectionBodyDimens.displayMathSize * fontScale,
              color: c.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
