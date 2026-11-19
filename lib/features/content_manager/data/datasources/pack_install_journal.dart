import 'dart:convert';
import 'dart:io';

/// Records an install in progress so a launch after the app was killed
/// mid-swap knows which version it was moving from and to.
class PackInstallJournal {
  const PackInstallJournal({
    required this.from,
    required this.to,
    required this.swapsPdf,
  });

  final int? from;
  final int to;
  final bool swapsPdf;

  /// Writes to [temp] and renames it to [file], so the journal on disk is
  /// either absent or complete.
  Future<void> writeTo(File file, File temp) async {
    await temp.writeAsString(
      jsonEncode({'from': from, 'to': to, 'swapsPdf': swapsPdf}),
      flush: true,
    );
    await temp.rename(file.path);
  }

  /// Null when the file is absent or unreadable.
  static Future<PackInstallJournal?> readFrom(File file) async {
    try {
      if (!await file.exists()) return null;
      final data = jsonDecode(await file.readAsString());
      if (data is! Map<String, dynamic>) return null;
      final to = data['to'];
      final from = data['from'];
      final swapsPdf = data['swapsPdf'];
      if (to is! int || (from != null && from is! int) || swapsPdf is! bool) {
        return null;
      }
      return PackInstallJournal(from: from as int?, to: to, swapsPdf: swapsPdf);
    } on FormatException {
      return null;
    } on FileSystemException {
      return null;
    }
  }
}
