import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/content_manager/presentation/constants/download_strings.dart';
import 'package:mualimi/features/content_manager/presentation/constants/grade_ordinals.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_icons.dart';

String _html(String name) => File('design/screens/light/$name.html').readAsStringSync();

void main() {
  final download = _html('Download');
  final all = [
    for (final n in ['Download', 'DownloadPaused', 'DownloadNoSpace', 'DownloadFailed', 'PackUpdate']) _html(n),
  ].join('\n');

  group('DownloadStrings match the design HTML', () {
    test('step label', () {
      final m = RegExp(r'margin-inline-start: 6px">([^<]+)</span>').firstMatch(download)!;
      expect(DownloadStrings.stepLabel, m.group(1));
    });

    test('back label', () {
      expect(DownloadStrings.back, RegExp(r'aria-label="([^"]+)"').firstMatch(download)!.group(1));
    });

    test('percent sign', () {
      final m = RegExp(r'<span style="font-size: 22px">([^<]+)</span>').firstMatch(download)!;
      expect(DownloadStrings.percentSign, m.group(1));
    });
  });

  group('NoSpace strings match the design HTML', () {
    final noSpace = _html('DownloadNoSpace');
    String only(String pattern) {
      final matches = RegExp(pattern).allMatches(noSpace).toList();
      expect(matches, hasLength(1), reason: pattern);
      return matches.single.group(1)!;
    }

    test('header title', () => expect(DownloadStrings.packTitle, only(r'<h1 [^>]*>([^<]+)</h1>')));

    test('status title', () {
      expect(DownloadStrings.noSpaceTitle, only(r'font-size: 19px; font-weight: 700">([^<]+)</div>'));
    });

    test('status body', () {
      expect(DownloadStrings.noSpaceBody, only(r'line-height: 1.75; color: #605B7D">([^<]+)</div>'));
    });

    test('required label', () {
      expect(DownloadStrings.requiredLabel, only(r'<span style="color: #605B7D">([^<]+)</span><b dir="ltr">'));
    });

    test('available label', () {
      expect(DownloadStrings.availableLabel, only(r'<span style="color: #605B7D">([^<]+)</span><b dir="ltr" style'));
    });

    test('check again button', () => expect(DownloadStrings.checkAgain, only(r'</svg>([^<]+)</button>')));
  });

  test('every DownloadIcons path appears in the design HTML', () {
    for (final p in [
      DownloadIcons.chevron,
      DownloadIcons.box,
      DownloadIcons.check,
      DownloadIcons.close,
      DownloadIcons.pause,
      DownloadIcons.refresh,
      DownloadIcons.info,
      DownloadIcons.wifiOff,
      DownloadIcons.phone,
      DownloadIcons.shieldCheck,
      DownloadIcons.download,
    ]) {
      expect(all.contains('d="$p"'), isTrue, reason: p);
    }
  });

  group('GradeOrdinals', () {
    test('9 matches the pack title in the design', () {
      expect(GradeOrdinals.of(9), 'التاسع');
      final title = RegExp(r'font-size: 17px; font-weight: 700">([^<]+)<').firstMatch(download)!.group(1)!;
      expect(title.endsWith(' ${GradeOrdinals.of(9)}'), isTrue);
    });

    test('11 is two words', () => expect(GradeOrdinals.of(11), 'الحادي عشر'));

    test('unknown grades fall back to the number', () {
      expect(GradeOrdinals.of(13), '13');
      expect(GradeOrdinals.of(0), '0');
    });

    test('1..12 are all distinct and non-numeric', () {
      final values = [for (var g = 1; g <= 12; g++) GradeOrdinals.of(g)];
      expect(values.toSet().length, 12);
      expect(values.any((v) => int.tryParse(v) != null), isFalse);
    });
  });
}
