import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  const Subject({required this.id, required this.name, required this.tutorEnabled});

  final String id;
  final String name;

  /// False for subjects the tutor can't handle yet (math).
  final bool tutorEnabled;

  @override
  List<Object?> get props => [id, name, tutorEnabled];
}
