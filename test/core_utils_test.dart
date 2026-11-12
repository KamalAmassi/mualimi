import 'dart:typed_data';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/utils/byte_formatter.dart';
import 'package:mualimi/core/utils/token_batcher.dart';
import 'package:mualimi/core/utils/vector_codec.dart';
import 'package:mualimi/core/utils/vector_math.dart';

void main() {
  group('VectorMath.cosine', () {
    test('identical direction is 1, orthogonal is 0, opposite is -1', () {
      expect(VectorMath.cosine([1, 2, 3], [2, 4, 6]), closeTo(1, 1e-9));
      expect(VectorMath.cosine([1, 0], [0, 1]), 0);
      expect(VectorMath.cosine([1, 0], [-1, 0]), closeTo(-1, 1e-9));
    });

    test('degenerate inputs give 0 instead of NaN', () {
      expect(VectorMath.cosine([], []), 0);
      expect(VectorMath.cosine([0, 0], [1, 1]), 0);
      expect(VectorMath.cosine([1, 2], [1, 2, 3]), 0);
    });
  });

  test('VectorCodec round-trips float32 values', () {
    final values = [0.5, -1.25, 3.0, 0.0];
    expect(VectorCodec.decode(VectorCodec.encode(values)), values);
  });

  test('VectorCodec decodes a view into a larger buffer', () {
    final bytes = VectorCodec.encode([1, 2]);
    final padded = Uint8List(bytes.length + 4)..setRange(4, 4 + bytes.length, bytes);
    expect(VectorCodec.decode(Uint8List.sublistView(padded, 4)), [1, 2]);
  });

  group('ByteFormatter', () {
    test('uses binary units', () {
      expect(ByteFormatter.format(512), '512 بايت');
      expect(ByteFormatter.format(2048), '2 ك.ب');
      expect(ByteFormatter.format(5 * 1024 * 1024), '5.0 م.ب');
      expect(ByteFormatter.format(2583000000), '2.4 غ.ب');
    });
  });

  group('TokenBatcher', () {
    test('delivers tokens in one batch per interval, in order', () {
      fakeAsync((async) {
        final batches = <String>[];
        final batcher = TokenBatcher(batches.add, interval: const Duration(milliseconds: 50));

        batcher.add('ا');
        batcher.add('ب');
        async.elapse(const Duration(milliseconds: 20));
        batcher.add('ج');
        expect(batches, isEmpty);

        async.elapse(const Duration(milliseconds: 40));
        expect(batches, ['ابج']);

        batcher.add('د');
        async.elapse(const Duration(milliseconds: 60));
        expect(batches, ['ابج', 'د']);
      });
    });

    test('flush emits immediately and nothing is emitted twice', () {
      fakeAsync((async) {
        final batches = <String>[];
        final batcher = TokenBatcher(batches.add);
        batcher.add('x');
        batcher.flush();
        expect(batches, ['x']);
        async.elapse(const Duration(seconds: 1));
        expect(batches, ['x']);
      });
    });

    test('flushing with nothing pending emits nothing', () {
      final batches = <String>[];
      TokenBatcher(batches.add).flush();
      expect(batches, isEmpty);
    });

    test('dispose drops pending tokens', () {
      fakeAsync((async) {
        final batches = <String>[];
        final batcher = TokenBatcher(batches.add)..add('x');
        batcher.dispose();
        async.elapse(const Duration(seconds: 1));
        expect(batches, isEmpty);
      });
    });
  });
}
