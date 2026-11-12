import 'package:equatable/equatable.dart';

import 'lesson_summary.dart';

class SubjectUnit extends Equatable {
  const SubjectUnit({required this.id, required this.title, required this.lessons});

  final String id;
  final String title;
  final List<LessonSummary> lessons;

  @override
  List<Object?> get props => [id, title, lessons];
}
