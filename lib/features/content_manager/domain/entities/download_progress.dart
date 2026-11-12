import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import 'download_phase.dart';

class DownloadProgress extends Equatable {
  const DownloadProgress({
    required this.phase,
    this.bytesDone = 0,
    this.totalBytes = 0,
    this.failure,
  });

  final DownloadPhase phase;
  final int bytesDone;
  final int totalBytes;
  final Failure? failure;

  /// 0..1 across all parts.
  double get fraction => totalBytes == 0 ? 0 : (bytesDone / totalBytes).clamp(0.0, 1.0);

  bool get isFinal =>
      phase == DownloadPhase.completed ||
      phase == DownloadPhase.canceled ||
      phase == DownloadPhase.failed;

  @override
  List<Object?> get props => [phase, bytesDone, totalBytes, failure];
}
