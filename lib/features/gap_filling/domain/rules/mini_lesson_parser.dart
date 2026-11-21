import '../entities/mini_lesson_block.dart';

/// Reads the Markdown subset of `docs/pack-format.md` that mini lessons use
/// into plain blocks: subheadings, paragraphs, list items and callouts.
abstract final class MiniLessonParser {
  static List<MiniLessonBlock> parse(String markdown) {
    final blocks = <MiniLessonBlock>[];
    for (final raw in markdown.split('\n')) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      if (line.startsWith('>')) {
        blocks.add(MiniLessonBlock(
            MiniLessonBlockKind.callout, _plain(line.substring(1))));
      } else if (line.startsWith('#')) {
        blocks.add(MiniLessonBlock(
            MiniLessonBlockKind.heading, _plain(line.replaceFirst(RegExp(r'^#+'), ''))));
      } else if (line.startsWith('- ')) {
        blocks.add(MiniLessonBlock(
            MiniLessonBlockKind.bullet, _plain(line.substring(2))));
      } else {
        blocks.add(MiniLessonBlock(MiniLessonBlockKind.paragraph, _plain(line)));
      }
    }
    return blocks;
  }

  static String _plain(String text) => text.replaceAll('**', '').trim();
}
