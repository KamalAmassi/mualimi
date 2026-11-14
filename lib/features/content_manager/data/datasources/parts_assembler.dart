import 'dart:io';

import '../../../../core/utils/file_parts_util.dart';

/// Builds the final file from verified parts. A single part is renamed into
/// place instead of copied; several parts are concatenated in an isolate.
abstract final class PartsAssembler {
  static Future<void> assemble(List<String> partPaths, String targetPath) async {
    if (partPaths.length != 1) {
      await FilePartsUtil.assemble(partPaths, targetPath);
      return;
    }
    final target = File(targetPath);
    // Rename does not overwrite on every platform; a copy would truncate.
    if (await target.exists()) await target.delete();
    try {
      await File(partPaths.single).rename(targetPath);
    } on FileSystemException {
      // e.g. parts and target on different volumes: fall back to a copy.
      await FilePartsUtil.assemble(partPaths, targetPath);
    }
  }
}
