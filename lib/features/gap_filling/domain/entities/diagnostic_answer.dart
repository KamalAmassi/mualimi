import 'package:equatable/equatable.dart';

class DiagnosticAnswer extends Equatable {
  const DiagnosticAnswer({required this.questionId, this.choiceIndex});

  final int questionId;

  /// Null when the student chose "I do not know".
  final int? choiceIndex;

  @override
  List<Object?> get props => [questionId, choiceIndex];
}
