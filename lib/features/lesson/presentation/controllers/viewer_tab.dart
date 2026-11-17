import '../widgets/viewer_strings.dart';

/// The viewer's three tabs, passed as `/viewer/:lessonId?tab=<name>`.
enum ViewerTab {
  explanation(ViewerStrings.explanationTab),
  pdf(ViewerStrings.pdfTab),
  solutions(ViewerStrings.solutionsTab);

  const ViewerTab(this.label);
  final String label;

  static ViewerTab parse(String? name) =>
      ViewerTab.values.firstWhere((t) => t.name == name, orElse: () => ViewerTab.explanation);
}
