import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/utils/byte_formatter.dart';
import 'package:mualimi/core/utils/token_batcher.dart';

void main() {
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
        final batcher = TokenBatcher(batches.add,
            interval: const Duration(milliseconds: 50));

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
