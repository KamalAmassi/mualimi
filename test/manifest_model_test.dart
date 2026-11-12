import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/limits.dart';
import 'package:mualimi/core/error/exceptions.dart';
import 'package:mualimi/features/content_manager/data/models/manifest_model.dart';

Map<String, dynamic> sample() => jsonDecode('''
{
  "schemaVersion": 1,
  "packs": [{
    "grade": 9, "track": null, "version": 3,
    "url": "https://a/pack.zip", "mirrors": ["https://b/pack.zip"],
    "size": 1000, "sha256": "abc",
    "subjects": [
      { "id": "science", "name": "العلوم والحياة", "tutorEnabled": true },
      { "id": "math", "name": "الرياضيات", "tutorEnabled": false }
    ]
  }],
  "model": {
    "id": "gemma-4-e2b", "version": 1, "fileName": "gemma-4-E2B-it.litertlm",
    "totalSize": 2583000000, "sha256": "def",
    "parts": [
      { "index": 1, "urls": ["https://b/1"], "size": 83000000, "sha256": "p1" },
      { "index": 0, "urls": ["https://a/0", "https://m/0"], "size": 524288000, "sha256": "p0" }
    ]
  },
  "embedding": { "id": "emb", "version": 1, "fileName": "e.tflite",
                 "totalSize": 0, "sha256": "", "parts": [] }
}
''') as Map<String, dynamic>;

void main() {
  test('parses a full manifest', () {
    final m = ManifestModel.fromJson(sample());
    expect(m.schemaVersion, 1);
    expect(m.packs, hasLength(1));
    final pack = m.packs.single;
    expect(pack.grade, 9);
    expect(pack.track, isNull);
    expect(pack.version, 3);
    expect(pack.mirrors, ['https://b/pack.zip']);
    expect(pack.subjects.map((s) => s.id), ['science', 'math']);
    expect(pack.subjects.last.tutorEnabled, isFalse);
  });

  test('parses the model and orders its parts by index', () {
    final model = ManifestModel.fromJson(sample()).model!;
    expect(model.fileName, 'gemma-4-E2B-it.litertlm');
    expect(model.parts.map((p) => p.index), [0, 1]);
    expect(model.parts.first.urls, ['https://a/0', 'https://m/0']);
    expect(model.largestPartSize, 524288000);
  });

  test('required free space is file + largest part + margin', () {
    final model = ManifestModel.fromJson(sample()).model!;
    expect(model.requiredFreeBytes, 2583000000 + 524288000 + Limits.downloadMarginBytes);
  });

  test('an embedding entry with no parts still parses', () {
    expect(ManifestModel.fromJson(sample()).embedding!.parts, isEmpty);
  });

  test('model and embedding are optional', () {
    final json = sample()
      ..remove('model')
      ..remove('embedding');
    final m = ManifestModel.fromJson(json);
    expect(m.model, isNull);
    expect(m.embedding, isNull);
  });

  test('packFor matches grade and track', () {
    final m = ManifestModel.fromJson(sample());
    expect(m.packFor(9)?.version, 3);
    expect(m.packFor(8), isNull);
    expect(m.packFor(9, track: 'scientific'), isNull);
  });

  test('a pack becomes a one-part artifact with its mirrors', () {
    final artifact = ManifestModel.fromJson(sample()).packs.single.asArtifact;
    expect(artifact.parts.single.urls, ['https://a/pack.zip', 'https://b/pack.zip']);
    expect(artifact.totalSize, 1000);
  });

  test('tutorEnabled defaults to true when omitted', () {
    final json = sample();
    ((json['packs'] as List).first['subjects'] as List).first.remove('tutorEnabled');
    expect(ManifestModel.fromJson(json).packs.single.subjects.first.tutorEnabled, isTrue);
  });

  group('malformed input throws ManifestException', () {
    test('unsupported schema version', () {
      expect(() => ManifestModel.fromJson(sample()..['schemaVersion'] = 2),
          throwsA(isA<ManifestException>()));
    });

    test('missing required field', () {
      expect(() => ManifestModel.fromJson(sample()..remove('packs')),
          throwsA(isA<ManifestException>()));
    });

    test('wrong field type', () {
      final json = sample();
      (json['packs'] as List).first['grade'] = 'nine';
      expect(() => ManifestModel.fromJson(json), throwsA(isA<ManifestException>()));
    });

    test('a part without urls', () {
      final json = sample();
      ((json['model'] as Map)['parts'] as List).first['urls'] = <String>[];
      expect(() => ManifestModel.fromJson(json), throwsA(isA<ManifestException>()));
    });
  });
}
