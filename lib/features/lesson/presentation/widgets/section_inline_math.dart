import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../../core/constants/app_colors.dart';

/// LaTeX rendered left to right, scrolling sideways when wider than the line.
/// A formula that does not parse shows its source instead.
class SectionInlineMath extends StatelessWidget {
  const SectionInlineMath({
    super.key,
    required this.tex,
    required this.style,
    this.display = false,
  });

  final String tex;
  final TextStyle style;
  final bool display;

  // flutter_math_fork expands U+00B7 to \cdotp, which is undefined inside
  // \text{}; U+22C5 is the glyph \cdotp draws and parses in both modes.
  static const _middleDot = '\u00B7';
  static const _dotOperator = '\u22C5';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Math.tex(
          tex.replaceAll(_middleDot, _dotOperator),
          mathStyle: display ? MathStyle.display : MathStyle.text,
          textStyle: style,
          onErrorFallback: (_) => Text(
            tex,
            style: style.copyWith(color: context.colors.textSecondary),
          ),
        ),
      ),
    );
  }
}
