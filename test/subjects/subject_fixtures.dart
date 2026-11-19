import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/subjects/domain/entities/lesson_summary.dart';
import 'package:mualimi/features/subjects/domain/entities/student_summary.dart';
import 'package:mualimi/features/subjects/domain/entities/subject_unit.dart';
import 'package:mualimi/features/subjects/domain/usecases/get_last_opened_lesson_usecase.dart';
import 'package:mualimi/features/subjects/domain/usecases/get_subject_detail_usecase.dart';
import 'package:mualimi/features/subjects/domain/usecases/watch_student_usecase.dart';
import 'package:mualimi/features/subjects/presentation/controllers/subject_controller.dart';
import 'package:mualimi/features/subjects/presentation/pages/subject_page.dart';

import 'home_fakes.dart';

const scienceUnits = [
  SubjectUnit(id: 'cell', title: 'الخلية', lessons: [
    LessonSummary(
        id: 'cell-1', title: 'الخلية الحية', tutorEnabled: true, bookPagesFrom: 10, bookPagesTo: 12),
    LessonSummary(id: 'cell-2', title: 'أجزاء الخلية', tutorEnabled: true, bookPagesFrom: 13),
  ]),
  SubjectUnit(id: 'static', title: 'الكهرباء الساكنة', lessons: [
    LessonSummary(
        id: 'charges', title: 'الشحنات الكهربائية', tutorEnabled: true,
        bookPagesFrom: 40, bookPagesTo: 43),
    LessonSummary(
        id: 'charging', title: 'طرق الشحن الكهربائي', tutorEnabled: true,
        bookPagesFrom: 44, bookPagesTo: 49),
    LessonSummary(id: 'electroscope', title: 'الكشّاف الكهربائي', tutorEnabled: true),
  ]),
];

const mathUnits = [
  SubjectUnit(id: 'equations', title: 'المعادلات', lessons: [
    LessonSummary(id: 'solve', title: 'حل المعادلات', tutorEnabled: false),
  ]),
];

const _designSize = Size(390, 844);

/// Pumps `/subject/<id>` over fakes; lesson and tutor routes are stubs.
class SubjectHarness {
  late FakeSubjectsRepository subjects;
  late FakeContinueLessonRepository progress;
  Object? tutorArguments;

  Future<void> pump(
    WidgetTester tester, {
    String subjectId = 'science',
    Map<String, List<SubjectUnit>> units = const {'science': scienceUnits, 'math': mathUnits},
    Map<String, String> lastOpened = const {},
    int? grade = 9,
    ThemeData? theme,
    double textScale = 1,
    Failure? failure,
  }) async {
    subjects = FakeSubjectsRepository(homeSubjects, units: units)..failure = failure;
    progress = FakeContinueLessonRepository(null, lastOpenedBySubject: lastOpened);
    tutorArguments = null;
    tester.view.physicalSize = _designSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(GetMaterialApp(
      theme: theme ?? AppTheme.light,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
        child: Directionality(textDirection: TextDirection.rtl, child: child!),
      ),
      initialRoute: AppRoutes.subjectOf(subjectId),
      getPages: [
        GetPage(
          name: AppRoutes.subject,
          page: SubjectPage.new,
          binding: BindingsBuilder(() {
            Get.put(SubjectController(
              GetSubjectDetailUseCase(subjects),
              GetLastOpenedLessonUseCase(progress),
              WatchStudentUseCase(
                  FakeStudentRepository(StudentSummary(name: 'أحمد', grade: grade))),
            ));
          }),
        ),
        GetPage(name: AppRoutes.lesson, page: () => Text('lesson ${Get.parameters['id']}')),
        GetPage(name: AppRoutes.tutor, page: () {
          tutorArguments = Get.arguments;
          return const Text('tutor');
        }),
      ],
    ));
    await tester.pumpAndSettle();
  }
}
