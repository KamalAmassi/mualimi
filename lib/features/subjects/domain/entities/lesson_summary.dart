import 'package:equatable/equatable.dart';

class LessonSummary extends Equatable {
  const LessonSummary({required this.id, required this.title, required this.tutorEnabled});

  final String id;
  final String title;
  final bool tutorEnabled;

  @override
  List<Object?> get props => [id, title, tutorEnabled];
}
