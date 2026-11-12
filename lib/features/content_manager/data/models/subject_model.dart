import '../../domain/entities/subject_info.dart';

class SubjectModel extends SubjectInfo {
  const SubjectModel({required super.id, required super.name, required super.tutorEnabled});

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
        id: json['id'] as String,
        name: json['name'] as String,
        tutorEnabled: json['tutorEnabled'] as bool? ?? true,
      );
}
