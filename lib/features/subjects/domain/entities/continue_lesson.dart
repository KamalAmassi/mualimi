import 'package:equatable/equatable.dart';

/// The lesson the student opened most recently, with the titles Home shows.
class ContinueLesson extends Equatable {
  const ContinueLesson({
    required this.lessonId,
    required this.lessonTitle,
    required this.subjectId,
    required this.subjectName,
    required this.unitTitle,
  });

  final String lessonId;
  final String lessonTitle;
  final String subjectId;
  final String subjectName;
  final String unitTitle;

  @override
  List<Object?> get props => [lessonId, lessonTitle, subjectId, subjectName, unitTitle];
}
