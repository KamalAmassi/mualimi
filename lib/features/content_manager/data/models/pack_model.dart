import '../../domain/entities/pack_info.dart';
import 'subject_model.dart';

class PackModel extends PackInfo {
  const PackModel({
    required super.grade,
    required super.track,
    required super.version,
    required super.url,
    required super.mirrors,
    required super.size,
    required super.sha256,
    required super.subjects,
  });

  factory PackModel.fromJson(Map<String, dynamic> json) => PackModel(
        grade: json['grade'] as int,
        track: json['track'] as String?,
        version: json['version'] as int,
        url: json['url'] as String,
        mirrors: (json['mirrors'] as List? ?? const []).cast<String>(),
        size: json['size'] as int,
        sha256: json['sha256'] as String,
        subjects: (json['subjects'] as List)
            .map((s) => SubjectModel.fromJson(s as Map<String, dynamic>))
            .toList(),
      );
}
