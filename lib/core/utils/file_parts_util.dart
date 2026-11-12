import 'dart:io';
import 'dart:isolate';

import '../constants/limits.dart';

abstract final class FilePartsUtil {
  /// Splits [source] into files named `<name>.partN` inside [outDir].
  static Future<List<File>> split(File source, int partSize, Directory outDir) async {
    await outDir.create(recursive: true);
    final raf = await source.open();
    final parts = <File>[];
    try {
      final total = await raf.length();
      var offset = 0;
      var index = 0;
      while (offset < total) {
        final length = (total - offset) < partSize ? total - offset : partSize;
        final part = File('${outDir.path}${Platform.pathSeparator}'
            '${source.uri.pathSegments.last}.part$index');
        await raf.setPosition(offset);
        await part.writeAsBytes(await raf.read(length));
        parts.add(part);
        offset += length;
        index++;
      }
    } finally {
      await raf.close();
    }
    return parts;
  }

  /// Appends each part to [target] in order, deleting each part once copied.
  /// Runs in a separate isolate so the UI never stalls.
  static Future<void> assemble(List<String> partPaths, String targetPath) {
    return Isolate.run(() => _assembleSync(partPaths, targetPath));
  }

  static void _assembleSync(List<String> partPaths, String targetPath) {
    final out = File(targetPath).openSync(mode: FileMode.write);
    try {
      for (final path in partPaths) {
        final part = File(path);
        final input = part.openSync();
        try {
          while (true) {
            final chunk = input.readSync(Limits.copyBufferBytes);
            if (chunk.isEmpty) break;
            out.writeFromSync(chunk);
          }
        } finally {
          input.closeSync();
        }
        part.deleteSync();
      }
    } finally {
      out.closeSync();
    }
  }
}
