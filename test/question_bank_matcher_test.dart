import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/utils/arabic_normalizer.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/bank_entry.dart';
import 'package:mualimi/features/curriculum_tutor/domain/services/question_bank_matcher.dart';
import 'package:mualimi/features/curriculum_tutor/domain/services/question_tokenizer.dart';

import 'support/tutor_fakes.dart';

BankEntry entry(int id, String question) => BankEntry(
      id: id,
      questionNormalized: ArabicNormalizer.normalize(question),
      answer: 'جواب $id',
      source: testSource,
    );

void main() {
  group('QuestionTokenizer', () {
    test('drops stopwords, one-letter words and duplicates', () {
      final tokens = QuestionTokenizer.tokens(
          ArabicNormalizer.normalize('ما هي طرق الشحن؟ الشحن و'));
      expect(tokens, ['طرق', 'الشحن']);
    });

    test('stopwords are compared in normalized form', () {
      expect(QuestionTokenizer.tokens(ArabicNormalizer.normalize('إلى أين')),
          isEmpty);
    });
  });

  group('QuestionBankMatcher', () {
    const matcher = QuestionBankMatcher();
    final candidates = [
      entry(1, 'ما هي طرق الشحن الكهربائي؟'),
      entry(2, 'ما فائدة التأريض؟'),
      entry(3, 'ما نص قانون حفظ الشحنة؟'),
    ];

    String normalize(String q) => ArabicNormalizer.normalize(q);

    test('an identical question scores 1', () {
      final match =
          matcher.best(normalize('ما هي طرق الشحن الكهربائي؟'), candidates);
      expect(match!.entry.id, 1);
      expect(match.score, 1);
    });

    test('a close rewording above the threshold matches', () {
      final match = matcher.best(normalize('ما طرق الشحن؟'), candidates);
      expect(match!.entry.id, 1);
      expect(match.score, closeTo(2 / 3, 1e-9));
    });

    test('a score below the threshold is no match', () {
      expect(
          matcher.best(
              normalize('ما هي طرق الشحن بالدلك والتماس والحث؟'), candidates),
          isNull);
    });

    test('the threshold is inclusive', () {
      const exact = QuestionBankMatcher(threshold: 2 / 3);
      expect(exact.best(normalize('ما طرق الشحن؟'), candidates), isNotNull);
    });

    test('the best of several candidates wins', () {
      final more = [entry(4, 'طرق الشحن'), ...candidates];
      expect(matcher.best(normalize('طرق الشحن'), more)!.entry.id, 4);
    });

    test('a question made only of stopwords never matches', () {
      expect(matcher.best(normalize('ما هو؟'), candidates), isNull);
    });

    test('no candidates is no match', () {
      expect(matcher.best(normalize('طرق الشحن'), const []), isNull);
    });
  });
}
