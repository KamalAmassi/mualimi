import 'package:equatable/equatable.dart';

class SubjectInfo extends Equatable {
  const SubjectInfo({required this.id, required this.name, required this.tutorEnabled});

  final String id;
  final String name;
  final bool tutorEnabled;

  @override
  List<Object?> get props => [id, name, tutorEnabled];
}
