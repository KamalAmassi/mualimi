import 'dart:io';
import 'dart:isolate';

import '../../../../core/utils/sha256_util.dart';

/// Checks a file against an expected SHA-256 hex digest. Injectable so tests
/// can count how many times a file is hashed.
typedef FileHashVerifier = Future<bool> Function(String path, String expectedHex);

/// Default [FileHashVerifier]: hashes in a separate isolate so large packs
/// never stall the UI. Only plain strings cross the isolate boundary.
abstract final class IsolateHashVerifier {
  static Future<bool> verify(String path, String expectedHex) async {
    // A missing file needs no isolate.
    if (!await File(path).exists()) return false;
    return Isolate.run(() => Sha256Util.verifyFile(File(path), expectedHex));
  }
}
