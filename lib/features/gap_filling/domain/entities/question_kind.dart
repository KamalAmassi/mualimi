enum QuestionKind {
  diagnostic,
  review;

  static QuestionKind parse(String value) =>
      values.firstWhere((k) => k.name == value, orElse: () => diagnostic);
}
