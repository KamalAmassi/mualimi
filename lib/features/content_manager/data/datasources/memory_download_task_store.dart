import 'download_task_store.dart';

/// In-memory [DownloadTaskStore]: the default when nothing persists ids.
class MemoryDownloadTaskStore implements DownloadTaskStore {
  final _ids = <String, Map<int, String>>{};

  @override
  Future<Map<int, String>> taskIds(String artifact) async => Map.of(_ids[artifact] ?? {});

  @override
  Future<void> saveTaskId(String artifact, int partIndex, String taskId) async =>
      (_ids[artifact] ??= {})[partIndex] = taskId;

  @override
  Future<void> removePart(String artifact, int partIndex) async => _ids[artifact]?.remove(partIndex);
}
