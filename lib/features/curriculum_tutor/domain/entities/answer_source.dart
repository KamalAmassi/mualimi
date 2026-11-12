import 'package:equatable/equatable.dart';

/// Where an answer came from: lesson and book page.
class AnswerSource extends Equatable {
  const AnswerSource({required this.lessonId, required this.page});

  final String lessonId;
  final int page;

  @override
  List<Object?> get props => [lessonId, page];
}
