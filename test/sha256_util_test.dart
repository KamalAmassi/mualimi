import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/utils/sha256_util.dart';

const _abc = 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad';
const _empty = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';

void main() {
  late Directory dir;

  setUp(() async => dir = await Directory.systemTemp.createTemp('sha_test'));
  tearDown(() => dir.delete(recursive: true));

  Future<File> fileWith(String text) async =>
      File('${dir.path}/f.bin').writeAsBytes(utf8.encode(text));

  test('hashes bytes (known vectors)', () {
    expect(Sha256Util.ofBytes(utf8.encode('abc')), _abc);
    expect(Sha256Util.ofBytes(const []), _empty);
  });

  test('file hash equals byte hash', () async {
    expect(await Sha256Util.ofFile(await fileWith('abc')), _abc);
  });

  test('hashes a file larger than one stream chunk', () async {
    final bytes = List.generate(300000, (i) => i % 256);
    final file = await File('${dir.path}/big.bin').writeAsBytes(bytes);
    expect(await Sha256Util.ofFile(file), Sha256Util.ofBytes(bytes));
  });

  test('verifyFile accepts a match, ignoring hex case', () async {
    final file = await fileWith('abc');
    expect(await Sha256Util.verifyFile(file, _abc), isTrue);
    expect(await Sha256Util.verifyFile(file, _abc.toUpperCase()), isTrue);
  });

  test('verifyFile rejects a mismatch', () async {
    expect(await Sha256Util.verifyFile(await fileWith('abd'), _abc), isFalse);
  });

  test('verifyFile is false for a missing file', () async {
    expect(await Sha256Util.verifyFile(File('${dir.path}/nope'), _abc), isFalse);
  });
}
