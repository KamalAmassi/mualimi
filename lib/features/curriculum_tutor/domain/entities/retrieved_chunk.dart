import 'package:equatable/equatable.dart';

/// A book passage found by search. `score` is 0..1 (higher is better).
class RetrievedChunk extends Equatable {
  const RetrievedChunk({
    required this.id,
    required this.lessonId,
    required this.page,
    required this.text,
    required this.score,
  });

  final int id;
  final String lessonId;
  final int page;
  final String text;
  final double score;

  RetrievedChunk withScore(double value) =>
      RetrievedChunk(id: id, lessonId: lessonId, page: page, text: text, score: value);

  @override
  List<Object?> get props => [id, lessonId, page, text, score];
}
