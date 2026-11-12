import '../../../../core/db/content/content_database.dart';
import '../../domain/entities/subject.dart';

class SubjectModel extends Subject {
  const SubjectModel({required super.id, required super.name, required super.tutorEnabled});

  factory SubjectModel.fromRow(SubjectRow row) =>
      SubjectModel(id: row.id, name: row.name, tutorEnabled: row.tutorEnabled);
}
