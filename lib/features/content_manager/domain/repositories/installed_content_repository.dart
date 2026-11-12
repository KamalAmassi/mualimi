abstract class InstalledContentRepository {
  Future<int?> installedPackVersion();
  Future<bool> isPackInstalled();
}
