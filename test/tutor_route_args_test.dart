import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/controllers/tutor_selection.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/routes/tutor_args.dart';
import 'package:mualimi/features/subjects/domain/entities/lesson_summary.dart';
import 'package:mualimi/features/subjects/domain/entities/subject.dart';
import 'package:mualimi/features/subjects/domain/entities/subject_unit.dart';
import 'package:mualimi/features/subjects/domain/repositories/subjects_repository.dart';
import 'package:mualimi/features/subjects/domain/usecases/get_subject_detail_usecase.dart';
import 'package:mualimi/features/subjects/domain/usecases/get_subjects_usecase.dart';

class _FakeSubjects implements SubjectsRepository {
  static const science =
      Subject(id: 'science', name: 'العلوم', tutorEnabled: true);
  static const math =
      Subject(id: 'math', name: 'الرياضيات', tutorEnabled: false);

  final units = const [
    SubjectUnit(id: 'u1', title: 'وحدة', lessons: [
      LessonSummary(id: 'l1', title: 'طرق الشحن', tutorEnabled: true),
      LessonSummary(id: 'l2', title: 'درس معطل', tutorEnabled: false),
    ]),
  ];

  @override
  Future<Either<Failure, List<Subject>>> getSubjects() async =>
      const Right([science, math]);

  @override
  Future<Either<Failure, Subject>> getSubject(String id) async =>
      id == 'science' ? const Right(science) : const Right(math);

  @override
  Future<Either<Failure, List<SubjectUnit>>> getUnits(String subjectId) async =>
      subjectId == 'science' ? Right(units) : const Right([]);
}

void main() {
  group('TutorArgs.from', () {
    test('reads subject and lesson', () {
      expect(
          TutorArgs.from(const TutorArgs(subjectId: 'science', lessonId: 'l1')),
          const TutorArgs(subjectId: 'science', lessonId: 'l1'));
    });

    test('the lesson is optional', () {
      final args = TutorArgs.from(const TutorArgs(subjectId: 'science'))!;
      expect(args.subjectId, 'science');
      expect(args.lessonId, isNull);
    });

    test('a blank lesson id means no lesson and ids are trimmed', () {
      final args = TutorArgs.from(
          const TutorArgs(subjectId: ' science ', lessonId: '  '))!;
      expect(args.subjectId, 'science');
      expect(args.lessonId, isNull);
    });

    test('missing arguments give null', () {
      expect(TutorArgs.from(null), isNull);
    });

    test('arguments of another type give null', () {
      expect(TutorArgs.from('science'), isNull);
      expect(TutorArgs.from({'subjectId': 'science'}), isNull);
      expect(TutorArgs.from(42), isNull);
    });

    test('an empty subject gives null', () {
      expect(TutorArgs.from(const TutorArgs(subjectId: '  ', lessonId: 'l1')),
          isNull);
    });
  });

  group('TutorSelection.applyArgs', () {
    late TutorSelection selection;

    setUp(() {
      final repository = _FakeSubjects();
      selection = TutorSelection(
          GetSubjectsUseCase(repository), GetSubjectDetailUseCase(repository));
    });

    test('pre-selects subject and lesson with its title', () async {
      await selection
          .applyArgs(const TutorArgs(subjectId: 'science', lessonId: 'l1'));
      expect(selection.subjectId.value, 'science');
      expect(selection.lessonId.value, 'l1');
      expect(selection.lessonTitle.value, 'طرق الشحن');
      expect(selection.subjectName, 'العلوم');
      expect(selection.supported.value, isTrue);
    });

    test('without a lesson only the subject is selected', () async {
      await selection.applyArgs(const TutorArgs(subjectId: 'science'));
      expect(selection.subjectId.value, 'science');
      expect(selection.lessonId.value, isNull);
      expect(selection.hasLesson, isFalse);
    });

    test('an unknown lesson falls back to the whole subject', () async {
      await selection
          .applyArgs(const TutorArgs(subjectId: 'science', lessonId: 'nope'));
      expect(selection.subjectId.value, 'science');
      expect(selection.lessonId.value, isNull);
    });

    test('an unknown subject leaves the selection unchanged', () async {
      selection.select(
          subject: 'science',
          lesson: 'l1',
          title: 'طرق الشحن',
          tutorEnabled: true);
      await selection
          .applyArgs(const TutorArgs(subjectId: 'ghost', lessonId: 'l1'));
      expect(selection.subjectId.value, 'science');
      expect(selection.lessonId.value, 'l1');
    });

    test('an unsupported subject or lesson marks the tutor unsupported',
        () async {
      await selection.applyArgs(const TutorArgs(subjectId: 'math'));
      expect(selection.supported.value, isFalse);
      await selection
          .applyArgs(const TutorArgs(subjectId: 'science', lessonId: 'l2'));
      expect(selection.supported.value, isFalse);
    });
  });
}
