enum MasterySource {
  diagnostic,
  review;

  static MasterySource parse(String value) =>
      values.firstWhere((s) => s.name == value, orElse: () => diagnostic);
}
