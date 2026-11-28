import 'package:archive/archive_io.dart';

import '../../../../core/error/exceptions.dart';

/// Extracts a pack zip after checking its layout, so a malformed pack fails
/// before anything is written. `images/` must be flat lowercase `.webp`
/// files, the only form the lesson viewer resolves.
class PackArchiveExtractor {
  const PackArchiveExtractor._();

  static const _imagesPrefix = 'images/';

  /// Runs synchronous zip I/O; call it inside an isolate.
  static Future<void> extract(String zipPath, String outputPath) async {
    final input = InputFileStream(zipPath);
    try {
      final archive = ZipDecoder().decodeStream(input);
      for (final entry in archive) {
        final problem = layoutProblem(entry.name,
            isFile: entry.isFile && !entry.isSymbolicLink);
        if (problem != null) {
          throw ManifestException('pack entry "${entry.name}" $problem');
        }
      }
      await extractArchiveToDisk(archive, outputPath);
      await archive.clear();
    } finally {
      await input.close();
    }
  }

  /// Null when [name] may appear in a pack.
  static String? layoutProblem(String name, {required bool isFile}) {
    if (name.contains(r'\')) return 'uses a backslash';
    if (name.startsWith('/') || RegExp(r'^[A-Za-z]:').hasMatch(name)) {
      return 'is an absolute path';
    }
    if (name.split('/').contains('..')) return 'leaves the pack';
    if (!name.startsWith(_imagesPrefix) || name == _imagesPrefix) return null;
    final fileName = name.substring(_imagesPrefix.length);
    if (!isFile || fileName.contains('/')) return 'is not a flat image file';
    if (fileName.startsWith('.') || !fileName.endsWith('.webp')) {
      return 'is not a .webp image';
    }
    return null;
  }
}
