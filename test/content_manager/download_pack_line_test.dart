import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/utils/byte_formatter.dart';
import 'package:mualimi/features/content_manager/domain/entities/pack_info.dart';
import 'package:mualimi/features/content_manager/domain/entities/subject_info.dart';
import 'package:mualimi/features/content_manager/presentation/constants/download_strings.dart';
import 'package:mualimi/features/content_manager/presentation/constants/grade_ordinals.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_pack_line.dart';

PackInfo _pack({int grade = 9, int version = 3, int size = 45 * 1024 * 1024, int subjects = 8}) => PackInfo(
      grade: grade,
      track: null,
      version: version,
      url: 'https://example.test/p.zip',
      mirrors: const [],
      size: size,
      sha256: 'sha',
      subjects: [
        for (var i = 0; i < subjects; i++) SubjectInfo(id: 's$i', name: 'n$i', tutorEnabled: false),
      ],
    );

void main() {
  group('title', () {
    test('is the prefix and the grade ordinal', () {
      expect(DownloadPackLine.title(_pack()), '${DownloadStrings.packTitlePrefix} ${GradeOrdinals.of(9)}');
    });

    test('uses two-word ordinals as they are', () {
      expect(DownloadPackLine.title(_pack(grade: 11)), endsWith(' ${GradeOrdinals.of(11)}'));
    });
  });

  group('details', () {
    test('subjects, version and size with Western digits', () {
      const s = DownloadStrings.packLineSeparator;
      expect(
        DownloadPackLine.details(_pack()),
        '8 ${DownloadStrings.subjectsWord}$s${DownloadStrings.versionWord} 3$s${ByteFormatter.format(45 * 1024 * 1024)}',
      );
    });

    test('size goes through ByteFormatter', () {
      for (final size in [512, 45 * 1024 * 1024, 1536 * 1024 * 1024]) {
        expect(DownloadPackLine.details(_pack(size: size)), endsWith(ByteFormatter.format(size)));
      }
      expect(ByteFormatter.format(45 * 1024 * 1024), startsWith('45.0 '));
    });

    test('has no Arabic-Indic digits', () {
      final text = DownloadPackLine.details(_pack(version: 12, subjects: 10));
      expect(RegExp('[\u0660-\u0669]').hasMatch(text), isFalse);
      expect(text, startsWith('10 '));
    });
  });

  group('pausedDetails', () {
    test('matches the paused design line', () {
      final html = File('design/screens/light/DownloadPaused.html').readAsStringSync();
      final line = RegExp(r'font-size: 13px; color: #ECE8FF">([^<]+)</div>').firstMatch(html)!.group(1)!;
      expect(DownloadPackLine.pausedDetails(62), line);
    });

    test('uses Western digits', () {
      expect(DownloadPackLine.pausedDetails(7), endsWith(' 7${DownloadStrings.percentSign}'));
    });
  });

  group('percentOf', () {
    test('rounds down', () {
      expect(DownloadPackLine.percentOf(29, 100), 29);
      expect(DownloadPackLine.percentOf(999, 1000), 99);
      expect(DownloadPackLine.percentOf(62, 100), 62);
    });

    test('reaches 100 only when every byte arrived', () {
      expect(DownloadPackLine.percentOf(100, 100), 100);
    });

    test('is 0 for an unknown total and clamps out-of-range bytes', () {
      expect(DownloadPackLine.percentOf(10, 0), 0);
      expect(DownloadPackLine.percentOf(-5, 100), 0);
      expect(DownloadPackLine.percentOf(150, 100), 100);
    });
  });
}
