import 'package:equatable/equatable.dart';

class BookSolution extends Equatable {
  const BookSolution({required this.number, required this.page, required this.solution});

  final int number;
  final int page;
  final String solution;

  @override
  List<Object?> get props => [number, page, solution];
}
