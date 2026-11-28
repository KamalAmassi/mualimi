import '../../../../core/utils/byte_formatter.dart';
import '../../domain/entities/pack_info.dart';
import '../constants/download_strings.dart';
import '../constants/grade_ordinals.dart';

/// Texts of the hero card on the download progress screen.
abstract final class DownloadPackLine {
  /// e.g. «رزمة الصف التاسع».
  static String title(PackInfo pack) => '${DownloadStrings.packTitlePrefix} ${GradeOrdinals.of(pack.grade)}';

  /// Subject count, version and size, e.g. «8 مواد · الإصدار 3 · 45.0 م.ب».
  static String details(PackInfo pack) => [
        '${pack.subjects.length} ${DownloadStrings.subjectsWord}',
        '${DownloadStrings.versionWord} ${pack.version}',
        ByteFormatter.format(pack.size),
      ].join(DownloadStrings.packLineSeparator);

  /// Hero subtitle of a paused download, e.g. «متوقف مؤقتاً · محفوظ حتى 62٪».
  static String pausedDetails(int percent) =>
      '${DownloadStrings.pausedLabel}${DownloadStrings.packLineSeparator}'
      '${DownloadStrings.savedUpTo} $percent${DownloadStrings.percentSign}';

  /// Whole percent of [done] out of [total], rounded down so 100 only shows
  /// once every byte has arrived. Integer math avoids 0.29 * 100 = 28.99….
  static int percentOf(int done, int total) => total <= 0 ? 0 : done.clamp(0, total) * 100 ~/ total;
}
