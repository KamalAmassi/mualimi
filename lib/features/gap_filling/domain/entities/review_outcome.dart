import 'package:equatable/equatable.dart';

class ReviewOutcome extends Equatable {
  const ReviewOutcome({required this.score, required this.stillWeak});

  final int score;
  final bool stillWeak;

  @override
  List<Object?> get props => [score, stillWeak];
}
