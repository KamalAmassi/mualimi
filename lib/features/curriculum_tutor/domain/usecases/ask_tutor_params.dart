import 'package:equatable/equatable.dart';

class AskTutorParams extends Equatable {
  const AskTutorParams({required this.question, required this.subjectId, this.lessonId});

  final String question;
  final String subjectId;
  final String? lessonId;

  @override
  List<Object?> get props => [question, subjectId, lessonId];
}
