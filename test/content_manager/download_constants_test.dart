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

  group('Progress strings match the design HTML', () {
    final rows = RegExp(
      r'font-size: 15px; font-weight: 600[^"]*">([^<]+)</div><div style="font-size: 12px; color: #[0-9A-F]+">([^<]+)</div>',
    ).allMatches(download).toList();

    test('pack title prefix is the hero title without the ordinal', () {
      final title = RegExp(r'font-size: 17px; font-weight: 700">([^<]+)<').firstMatch(download)!.group(1)!;
      expect(title, '${DownloadStrings.packTitlePrefix} ${GradeOrdinals.of(9)}');
    });

    test('pack line words and separator', () {
      final line = RegExp(r'color: #ECE8FF">([^<]*·[^<]*)</div>').firstMatch(download)!.group(1)!;
      final parts = line.split(DownloadStrings.packLineSeparator);
      expect(parts, hasLength(3));
      expect(parts[0].split(' ').last, DownloadStrings.subjectsWord);
      expect(parts[1].split(' ').first, DownloadStrings.versionWord);
    });

    test('hero side text', () {
      expect(download.contains('color: #ECE8FF">${DownloadStrings.onceOnly}</div>'), isTrue);
    });

    test('checklist rows', () {
      expect([for (final r in rows) (r.group(1), r.group(2))], [
        (DownloadStrings.spaceCheckStep, DownloadStrings.spaceCheckDone),
        (DownloadStrings.contentStep, DownloadStrings.contentStepHint),
        (DownloadStrings.integrityStep, DownloadStrings.integrityStepHint),
        (DownloadStrings.installStep, DownloadStrings.installStepHint),
      ]);
    });

    test('resume banner', () {
      expect(download.contains('<b>${DownloadStrings.resumeTipLead}</b> ${DownloadStrings.resumeTipBody}</div>'), isTrue);
    });

    test('offline note is the second half of the splash tagline', () {
      final splash = File('lib/features/onboarding/presentation/widgets/splash_strings.dart').readAsStringSync();
      final tagline = RegExp("tagline = '([^']+)'").firstMatch(splash)!.group(1)!;
      expect(tagline.split(DownloadStrings.packLineSeparator).last, DownloadStrings.worksOffline);
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

  group('Failed strings match the design HTML', () {
    final failed = _html('DownloadFailed');
    String only(String pattern) {
      final matches = RegExp(pattern).allMatches(failed).toList();
      expect(matches, hasLength(1), reason: pattern);
      return matches.single.group(1)!;
    }

    final rows = RegExp(
      r'font-size: 15px; font-weight: 600[^"]*">([^<]+)</div><div style="font-size: 12px; color: #[0-9A-F]+">([^<]+)</div>',
    ).allMatches(failed).toList();

    test('status title', () {
      expect(DownloadStrings.integrityTitle, only(r'font-size: 19px; font-weight: 700">([^<]+)</div>'));
    });

    test('status body', () {
      expect(DownloadStrings.integrityBody, only(r'line-height: 1.75; color: #605B7D">([^<]+)</div>'));
    });

    test('checklist rows', () {
      expect(rows, hasLength(3));
      expect([for (final r in rows) (r.group(1), r.group(2))], [
        (DownloadStrings.spaceCheckStep, DownloadStrings.spaceCheckDone),
        (DownloadStrings.contentStep, DownloadStrings.contentDone),
        (DownloadStrings.integrityStep, DownloadStrings.integrityMismatch),
      ]);
    });

    test('redownload button', () => expect(DownloadStrings.redownload, only(r'</svg>([^<]+)</button>')));

    test('generic body is exactly the approved wording', () {
      const expected = [
        0x062A, 0x062D, 0x0642, 0x0642, 0x0020, 0x0645, 0x0646, 0x0020, 0x0627, 0x062A, 0x0635, 0x0627, //
        0x0644, 0x0643, 0x0020, 0x0628, 0x0627, 0x0644, 0x0625, 0x0646, 0x062A, 0x0631, 0x0646, 0x062A, //
        0x0020, 0x062B, 0x0645, 0x0020, 0x062D, 0x0627, 0x0648, 0x0644, 0x0020, 0x0645, 0x0631, 0x0629, //
        0x0020, 0x0623, 0x062E, 0x0631, 0x0649, 0x002E, 0x0020, 0x0633, 0x064A, 0x0643, 0x0645, 0x0644, //
        0x0020, 0x0627, 0x0644, 0x062A, 0x0646, 0x0632, 0x064A, 0x0644, 0x0020, 0x0645, 0x0646, 0x0020, //
        0x062D, 0x064A, 0x062B, 0x0020, 0x062A, 0x0648, 0x0642, 0x0641, 0x002E,
      ];
      expect(DownloadStrings.failedBody.runes.toList(), expected);
      expect(DownloadStrings.failedBody.length, 69);
    });
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
