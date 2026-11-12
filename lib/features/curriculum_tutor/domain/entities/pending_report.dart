import 'package:equatable/equatable.dart';

/// An answer report waiting to be sent once the device is online.
class PendingReport extends Equatable {
  const PendingReport({
    this.id,
    required this.question,
    required this.answer,
    required this.reason,
    this.lessonId,
    this.note,
  });

  final int? id;
  final String? lessonId;
  final String question;
  final String answer;
  final String reason;
  final String? note;

  @override
  List<Object?> get props => [id, lessonId, question, answer, reason, note];
}
