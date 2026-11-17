import 'dart:io';
import 'dart:isolate';

import '../../domain/entities/storage_usage.dart';

/// Measures the installed pack on disk. Walking the PDF folder runs off the UI thread.
class StorageUsageLocalDataSource {
  StorageUsageLocalDataSource({required this.contentDbPath, required this.pdfDirPath});

  final String contentDbPath;
  final String pdfDirPath;

  Future<StorageUsage> measure() {
    final dbPath = contentDbPath;
    final pdfPath = pdfDirPath;
    return Isolate.run(() => StorageUsage(
          packBytes: _fileBytes(File(dbPath)),
          pdfBytes: _folderBytes(Directory(pdfPath)),
        ));
  }

  static int _fileBytes(File file) {
    try {
      return file.existsSync() ? file.lengthSync() : 0;
    } on FileSystemException {
      return 0;
    }
  }

  static int _folderBytes(Directory dir) {
    if (!dir.existsSync()) return 0;
    var total = 0;
    try {
      for (final entity in dir.listSync(recursive: true, followLinks: false)) {
        if (entity is File) total += _fileBytes(entity);
      }
    } on FileSystemException {
      return total;
    }
    return total;
  }
}