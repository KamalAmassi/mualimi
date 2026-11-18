import 'package:equatable/equatable.dart';

class LessonSummary extends Equatable {
  const LessonSummary({
    required this.id,
    required this.title,
    required this.tutorEnabled,
    this.bookPagesFrom,
    this.bookPagesTo,
  });

  final String id;
  final String title;
  final bool tutorEnabled;

  /// Printed page numbers of the learning pack; null when the pack has none.
  final int? bookPagesFrom;
  final int? bookPagesTo;

  @override
  List<Object?> get props => [id, title, tutorEnabled, bookPagesFrom, bookPagesTo];
}
