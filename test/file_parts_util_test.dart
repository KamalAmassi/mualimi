import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/utils/file_parts_util.dart';
import 'package:mualimi/core/utils/sha256_util.dart';

void main() {
  late Directory dir;

  setUp(() async => dir = await Directory.systemTemp.createTemp('parts_test'));
  tearDown(() => dir.delete(recursive: true));

  Future<File> source(int length) async {
    final bytes = List.generate(length, (i) => (i * 7 + 3) % 256);
    return File('${dir.path}/model.bin').writeAsBytes(bytes);
  }

  test('splits into parts of the requested size, last one shorter', () async {
    final parts = await FilePartsUtil.split(await source(1000), 300, Directory('${dir.path}/p'));
    expect(parts.map((f) => f.lengthSync()), [300, 300, 300, 100]);
  });

  test('an exact multiple has no empty trailing part', () async {
    final parts = await FilePartsUtil.split(await source(600), 300, Directory('${dir.path}/p'));
    expect(parts, hasLength(2));
  });

  test('reassembled file has the same hash as the original', () async {
    final original = await source(1000);
    final originalHash = await Sha256Util.ofFile(original);
    final parts = await FilePartsUtil.split(original, 300, Directory('${dir.path}/p'));

    final target = File('${dir.path}/out.bin');
    await FilePartsUtil.assemble(parts.map((f) => f.path).toList(), target.path);

    expect(await Sha256Util.ofFile(target), originalHash);
    expect(await target.length(), 1000);
  });

  test('assembly deletes each part once it is copied', () async {
    final parts = await FilePartsUtil.split(await source(700), 300, Directory('${dir.path}/p'));
    await FilePartsUtil.assemble(parts.map((f) => f.path).toList(), '${dir.path}/out.bin');
    expect(parts.any((f) => f.existsSync()), isFalse);
  });

  test('assembly keeps the order of the paths it is given', () async {
    final a = await File('${dir.path}/a').writeAsString('AA');
    final b = await File('${dir.path}/b').writeAsString('BB');
    await FilePartsUtil.assemble([b.path, a.path], '${dir.path}/out');
    expect(await File('${dir.path}/out').readAsString(), 'BBAA');
  });

  test('a corrupted part is detected by the final hash', () async {
    final original = await source(900);
    final originalHash = await Sha256Util.ofFile(original);
    final parts = await FilePartsUtil.split(original, 300, Directory('${dir.path}/p'));
    await parts[1].writeAsBytes(List.filled(300, 0));

    final target = File('${dir.path}/out.bin');
    await FilePartsUtil.assemble(parts.map((f) => f.path).toList(), target.path);
    expect(await Sha256Util.verifyFile(target, originalHash), isFalse);
  });
}
