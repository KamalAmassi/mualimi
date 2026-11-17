import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/features/onboarding/presentation/widgets/grade_strings.dart';

/// Every text node of the design HTML, trimmed, in document order.
List<String> _htmlTexts(String html) => RegExp('>([^<]+)<')
    .allMatches(html)
    .map((m) => m.group(1)!.trim())
    .where((text) => text.isNotEmpty)
    .toList();

void main() {
  final texts = _htmlTexts(File('design/screens/light/Grade.html').readAsStringSync());
  final designTitle = texts.firstWhere((text) => text.endsWith(GradeStrings.questionMark));
  final designButton = texts.last;

  test('fixed strings equal the Grade design HTML text exactly', () {
    for (final value in [
      AppStrings.grade,
      GradeStrings.subtitle,
      GradeStrings.step,
      AppStrings.gradePrefix,
      AppStrings.comingSoon,
    ]) {
      expect(texts, contains(value));
    }
  });

  test('the title with the design sample name equals the design title', () {
    final sampleName = designTitle
        .substring(0, designTitle.length - GradeStrings.questionMark.length)
        .split(' ')
        .last;
    expect(GradeStrings.title(sampleName), designTitle);
  });

  test('without a name the title drops the vocative and keeps the question', () {
    expect(GradeStrings.title(''), '${GradeStrings.titlePrefix}${GradeStrings.questionMark}');
    expect(designTitle.startsWith('${GradeStrings.titlePrefix} ${GradeStrings.vocative} '), isTrue);
  });

  test('the download label for grade 9 equals the design button', () {
    expect(GradeStrings.downloadLabel(9), designButton);
  });
}
