/// Page map of the development science PDF. The offset between PDF and
/// printed pages changes inside the book, as in a real ministry file.
abstract final class DevSeedPackPages {
  static const lastPdfPage = 32;
  static const _unnumberedPlate = 24;

  /// The number printed on [pdfPage]; empty for an unnumbered page.
  static String printedPageOf(int pdfPage) {
    if (pdfPage <= 4) return const ['i', 'ii', 'iii', 'iv'][pdfPage - 1];
    if (pdfPage <= 23) return '${pdfPage - 4}';
    if (pdfPage == _unnumberedPlate) return '';
    return '${pdfPage - 5}';
  }

  static int pdfPageOf(int printedPage) =>
      printedPage <= 19 ? printedPage + 4 : printedPage + 5;
}
