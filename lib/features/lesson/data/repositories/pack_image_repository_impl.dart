import 'package:path/path.dart' as p;

import '../../../../core/services/app_paths_service.dart';
import '../../domain/repositories/pack_image_repository.dart';

/// Images sit flat in `images/` at the pack root (`docs/pack-format.md`).
class PackImageRepositoryImpl implements PackImageRepository {
  PackImageRepositoryImpl(this._paths);
  final AppPathsService _paths;

  static const _imagesDir = 'images';
  static final _reference = RegExp(r'^images/([^/\\:]+\.webp)$');

  @override
  String? imagePathOf(String relativePath) {
    final fileName = _reference.firstMatch(relativePath)?.group(1);
    if (fileName == null || fileName.startsWith('.')) return null;
    return p.join(_paths.packsDir.path, _imagesDir, fileName);
  }
}
