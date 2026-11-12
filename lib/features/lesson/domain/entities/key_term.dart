import 'package:equatable/equatable.dart';

class KeyTerm extends Equatable {
  const KeyTerm({required this.term, required this.definition});

  final String term;
  final String definition;

  @override
  List<Object?> get props => [term, definition];
}
