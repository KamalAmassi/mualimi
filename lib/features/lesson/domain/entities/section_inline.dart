import 'package:equatable/equatable.dart';

/// A run inside a line of a section body.
sealed class SectionInline extends Equatable {
  const SectionInline();
}

class TextInline extends SectionInline {
  const TextInline(this.text, {this.bold = false});

  final String text;
  final bool bold;

  @override
  List<Object?> get props => [text, bold];
}

/// LaTeX written between single dollar signs.
class MathInline extends SectionInline {
  const MathInline(this.tex, {this.bold = false});

  final String tex;
  final bool bold;

  @override
  List<Object?> get props => [tex, bold];
}
