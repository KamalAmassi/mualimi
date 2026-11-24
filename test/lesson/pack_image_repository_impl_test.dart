import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/services/app_paths_service.dart';
import 'package:mualimi/features/lesson/data/repositories/pack_image_repository_impl.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory root;
  late AppPathsService paths;
  late PackImageRepositoryImpl images;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('pack_images');
    paths = await AppPathsService(rootOverride: root).init();
    images = PackImageRepositoryImpl(paths);
  });

  tearDown(() => root.delete(recursive: true));

  test('an images/ reference resolves inside the installed pack', () {
    expect(images.imagePathOf('images/charge_01.webp'),
        p.join(paths.packsDir.path, 'images', 'charge_01.webp'));
  });

  test('references outside the flat images folder are rejected', () {
    for (final path in [
      'images/sub/a.webp',
      'images/../content.db.webp',
      '../images/a.webp',
      '/images/a.webp',
      r'images\a.webp',
      'images/.webp',
      'images/a.png',
      'pdf/a.webp',
      'a.webp',
      '',
    ]) {
      expect(images.imagePathOf(path), isNull, reason: path);
    }
  });
}
