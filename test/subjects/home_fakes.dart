import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/features/subjects/domain/entities/continue_lesson.dart';
import 'package:mualimi/features/subjects/domain/entities/student_summary.dart';
import 'package:mualimi/features/subjects/domain/entities/subject.dart';
import 'package:mualimi/features/subjects/domain/entities/subject_unit.dart';
import 'package:mualimi/features/subjects/domain/repositories/continue_lesson_repository.dart';
import 'package:mualimi/features/subjects/domain/repositories/network_status_repository.dart';
import 'package:mualimi/features/subjects/domain/repositories/student_repository.dart';
import 'package:mualimi/features/subjects/domain/repositories/subjects_repository.dart';

const homeSubjects = [
  Subject(id: 'arabic', name: 'اللغة العربية', tutorEnabled: true),
  Subject(id: 'english', name: 'اللغة الإنجليزية', tutorEnabled: true),
  Subject(id: 'math', name: 'الرياضيات', tutorEnabled: false),
  Subject(id: 'science', name: 'العلوم والحياة', tutorEnabled: true),
  Subject(id: 'islamic', name: 'التربية الإسلامية', tutorEnabled: true),
  Subject(id: 'history', name: 'التاريخ', tutorEnabled: true),
  Subject(id: 'geography', name: 'الجغرافيا', tutorEnabled: true),
  Subject(id: 'technology', name: 'التكنولوجيا', tutorEnabled: true),
];

const homeContinueLesson = ContinueLesson(
  lessonId: 'science-9-charging',
  lessonTitle: 'طرق الشحن الكهربائي',
  subjectId: 'science',
  subjectName: 'العلوم والحياة',
  unitTitle: 'الكهرباء الساكنة',
);

class FakeSubjectsRepository implements SubjectsRepository {
  FakeSubjectsRepository(this.subjects, {this.units = const {}});
  final List<Subject> subjects;
  final Map<String, List<SubjectUnit>> units;

  /// When set, every read fails with it.
  Failure? failure;

  @override
  Future<Either<Failure, List<Subject>>> getSubjects() async =>
      failure != null ? Left(failure!) : Right(subjects);

  @override
  Future<Either<Failure, Subject>> getSubject(String id) async =>
      failure != null ? Left(failure!) : Right(subjects.firstWhere((s) => s.id == id));

  @override
  Future<Either<Failure, List<SubjectUnit>>> getUnits(String subjectId) async =>
      failure != null ? Left(failure!) : Right(units[subjectId] ?? const []);
}

class FakeContinueLessonRepository implements ContinueLessonRepository {
  FakeContinueLessonRepository(this.lesson, {this.lastOpenedBySubject = const {}});
  ContinueLesson? lesson;
  Map<String, String> lastOpenedBySubject;

  @override
  Future<Either<Failure, ContinueLesson?>> getContinueLesson() async => Right(lesson);

  @override
  Future<Either<Failure, String?>> getLastOpenedLessonId(String subjectId) async =>
      Right(lastOpenedBySubject[subjectId]);
}

class FakeStudentRepository implements StudentRepository {
  FakeStudentRepository(this.current);
  StudentSummary current;
  final _changes = StreamController<StudentSummary>.broadcast();

  void emit(StudentSummary student) => _changes.add(current = student);

  @override
  Stream<StudentSummary> watch() async* {
    yield current;
    yield* _changes.stream;
  }
}

class FakeNetworkStatusRepository implements NetworkStatusRepository {
  FakeNetworkStatusRepository({required this.online});
  bool online;
  final _changes = StreamController<bool>.broadcast();

  void emit(bool value) => _changes.add(online = value);

  @override
  Stream<bool> watchOnline() async* {
    yield online;
    yield* _changes.stream;
  }
}
