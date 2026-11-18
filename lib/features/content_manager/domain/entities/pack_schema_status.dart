/// How a pack's `pack_meta.schema_version` compares to the schema the app
/// reads. Anything but [compatible] means the pack must be downloaded again.
enum PackSchemaStatus {
  compatible,
  outdated,
  newer,
  unreadable;

  static PackSchemaStatus of(int? found, int expected) {
    if (found == null) return unreadable;
    if (found < expected) return outdated;
    if (found > expected) return newer;
    return compatible;
  }
}
