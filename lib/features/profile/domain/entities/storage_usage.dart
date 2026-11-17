import 'package:equatable/equatable.dart';

/// Bytes the installed pack takes on the device.
class StorageUsage extends Equatable {
  const StorageUsage({required this.packBytes, required this.pdfBytes});

  /// content.db alone.
  final int packBytes;
  final int pdfBytes;

  int get totalBytes => packBytes + pdfBytes;

  @override
  List<Object?> get props => [packBytes, pdfBytes];
}