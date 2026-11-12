import 'dart:io';

import 'package:crypto/crypto.dart';

abstract final class Sha256Util {
  static String ofBytes(List<int> bytes) => sha256.convert(bytes).toString();

  /// Streams the file, so large files never load into memory.
  static Future<String> ofFile(File file) async {
    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString();
  }

  static Future<bool> verifyFile(File file, String expectedHex) async {
    if (!await file.exists()) return false;
    final actual = await ofFile(file);
    return actual.toLowerCase() == expectedHex.toLowerCase();
  }
}
