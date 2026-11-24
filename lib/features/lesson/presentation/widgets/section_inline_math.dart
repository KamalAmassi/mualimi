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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Math.tex(
          tex,
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
