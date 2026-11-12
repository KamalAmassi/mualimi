import 'package:equatable/equatable.dart';

class PeerDevice extends Equatable {
  const PeerDevice({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
