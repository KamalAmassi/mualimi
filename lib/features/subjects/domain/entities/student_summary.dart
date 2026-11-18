import 'package:equatable/equatable.dart';

class StudentSummary extends Equatable {
  const StudentSummary({required this.name, required this.grade});

  final String name;

  /// Null until the student picks a grade.
  final int? grade;

  @override
  List<Object?> get props => [name, grade];
}
