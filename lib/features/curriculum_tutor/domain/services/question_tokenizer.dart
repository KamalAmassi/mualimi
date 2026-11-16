import '../../../../core/utils/arabic_normalizer.dart';

/// Splits a normalized question into the words worth matching on.
abstract final class QuestionTokenizer {
  static final _nonWord = RegExp(r'[^\p{L}\p{N}]+', unicode: true);
  static const _minTokenLength = 2;

  static const _rawStopwords = [
    'ما',
    'ماذا',
    'هل',
    'كيف',
    'لماذا',
    'متى',
    'أين',
    'كم',
    'من',
    'في',
    'على',
    'إلى',
    'عن',
    'مع',
    'هو',
    'هي',
    'هم',
    'هذا',
    'هذه',
    'ذلك',
    'تلك',
    'التي',
    'الذي',
    'الذين',
    'أو',
    'ثم',
    'لا',
    'إن',
    'أن',
    'إنه',
    'أي',
    'كل',
    'بعض',
    'قد',
    'كان',
    'يكون',
    'تكون',
    'بين',
    'عند',
    'إذا',
    'لو',
    'أيضاً',
    'يا',
    'له',
    'لها',
    'به',
    'بها',
    'فيه',
    'فيها',
    'منه',
    'منها',
    'عنه',
    'عنها',
    'اشرح',
    'وضح',
    'اذكر',
    'عرف',
    'علل',
  ];

  static final Set<String> stopwords = {
    for (final w in _rawStopwords) ArabicNormalizer.normalize(w),
  };

  static List<String> tokens(String normalizedQuestion) {
    final seen = <String>{};
    return [
      for (final t in normalizedQuestion.split(_nonWord))
        if (t.length >= _minTokenLength &&
            !stopwords.contains(t) &&
            seen.add(t))
          t,
    ];
  }
}
