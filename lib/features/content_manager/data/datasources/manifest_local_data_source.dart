import 'dart:convert';
import 'dart:io';

import '../../../../core/error/exceptions.dart';

/// The last good manifest, so the app still knows its packs offline.
class ManifestLocalDataSource {
  ManifestLocalDataSource(this._file);
  final File _file;

  Future<Map<String, dynamic>?> read() async {
    if (!await _file.exists()) return null;
    try {
      return jsonDecode(await _file.readAsString()) as Map<String, dynamic>;
    } on FormatException {
      throw const ManifestException('cached manifest is corrupt');
    }
  }

  Future<void> write(Map<String, dynamic> json) => _file.writeAsString(jsonEncode(json));
}
