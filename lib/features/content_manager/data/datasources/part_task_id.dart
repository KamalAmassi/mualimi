import '../../domain/entities/artifact_info.dart';

/// Deterministic background-download task ids, one per artifact version,
/// part and mirror, so a task (and its resume data) is found again after a
/// network cut or an app restart.
class PartTaskId {
  const PartTaskId._();

  static String of(ArtifactInfo a, int partIndex, int mirrorIndex) =>
      '${_prefix(a, partIndex)}$mirrorIndex';

  /// True when [taskId] belongs to this artifact version and part.
  static bool isFor(String taskId, ArtifactInfo a, int partIndex) =>
      taskId.startsWith(_prefix(a, partIndex)) && mirrorOf(taskId) != null;

  /// The mirror index encoded in [taskId], or null if it is not one of ours.
  static int? mirrorOf(String taskId) {
    final i = taskId.lastIndexOf('-m');
    return i < 0 ? null : int.tryParse(taskId.substring(i + 2));
  }

  static String _prefix(ArtifactInfo a, int partIndex) => '${a.id}-v${a.version}-p$partIndex-m';
}
