import 'package:equatable/equatable.dart';

import 'lesson_section.dart';

class Lesson extends Equatable {
  const Lesson({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.tutorEnabled,
    required this.sections,
    this.videoUrl,
    this.videoChaptersJson,
    this.bookPagesFrom,
    this.bookPagesTo,
    this.pdfFile,
  });

  final String id;
  final String subjectId;
  final String title;
  final bool tutorEnabled;
  final List<LessonSection> sections;
  final String? videoUrl;
  final String? videoChaptersJson;
  final int? bookPagesFrom;
  final int? bookPagesTo;
  final String? pdfFile;

  @override
  List<Object?> get props => [
        id, subjectId, title, tutorEnabled, sections, videoUrl,
        videoChaptersJson, bookPagesFrom, bookPagesTo, pdfFile,
      ];
}
