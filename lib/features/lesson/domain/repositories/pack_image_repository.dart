abstract class PackImageRepository {
  /// The file path of an image referenced from a section body as
  /// `images/<file>.webp`, or null when [relativePath] is not such a reference.
  /// The file may not exist yet.
  String? imagePathOf(String relativePath);
}
