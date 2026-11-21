import 'package:equatable/equatable.dart';

enum MiniLessonBlockKind { heading, paragraph, bullet, callout }

class MiniLessonBlock extends Equatable {
  const MiniLessonBlock(this.kind, this.text);

  final MiniLessonBlockKind kind;
  final String text;

  @override
  List<Object?> get props => [kind, text];
}
