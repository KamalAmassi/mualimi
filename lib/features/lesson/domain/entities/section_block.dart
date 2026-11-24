import 'package:equatable/equatable.dart';

import 'callout_kind.dart';
import 'section_inline.dart';

/// One block of a section body, in the Markdown subset of `docs/pack-format.md`.
sealed class SectionBlock extends Equatable {
  const SectionBlock();
}

/// `##` (level 2) or `###` (level 3).
class HeadingBlock extends SectionBlock {
  const HeadingBlock(this.level, this.inlines);

  final int level;
  final List<SectionInline> inlines;

  @override
  List<Object?> get props => [level, inlines];
}

class ParagraphBlock extends SectionBlock {
  const ParagraphBlock(this.inlines);

  final List<SectionInline> inlines;

  @override
  List<Object?> get props => [inlines];
}

class BulletListBlock extends SectionBlock {
  const BulletListBlock(this.items);

  final List<List<SectionInline>> items;

  @override
  List<Object?> get props => [items];
}

/// A blockquote opened by a callout marker; [inlines] keep the bold marker.
class CalloutBlock extends SectionBlock {
  const CalloutBlock(this.kind, this.inlines);

  final CalloutKind kind;
  final List<SectionInline> inlines;

  @override
  List<Object?> get props => [kind, inlines];
}

class DisplayMathBlock extends SectionBlock {
  const DisplayMathBlock(this.tex);

  final String tex;

  @override
  List<Object?> get props => [tex];
}

/// [path] is relative to the pack root, as written in the body.
class ImageBlock extends SectionBlock {
  const ImageBlock({required this.caption, required this.path});

  final String caption;
  final String path;

  @override
  List<Object?> get props => [caption, path];
}

/// Every row has as many cells as [header].
class TableBlock extends SectionBlock {
  const TableBlock({required this.header, required this.rows});

  final List<List<SectionInline>> header;
  final List<List<List<SectionInline>>> rows;

  @override
  List<Object?> get props => [header, rows];
}
