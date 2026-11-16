import 'package:drift/drift.dart';

import '../../../utils/arabic_normalizer.dart';
import '../content_database.dart';
import 'dev_seed_charging_basics.dart';
import 'dev_seed_charging_induction.dart';
import 'dev_seed_force_lesson.dart';
import 'dev_seed_prebuilt_answers.dart';
import 'dev_seed_question_bank.dart';

/// Development data for grade 9 science (unit "الكهرباء الساكنة") and one math
/// lesson. Real packs ship with the same tables. Loaded in debug builds and tests only.
abstract final class DevSeedScienceG9 {
  static const subjectId = 'science';
  static const mathSubjectId = 'math';
  static const unitId = 'science-9-u1';
  static const lessonId = 'science-9-charging';
  static const otherLessonId = 'science-9-force';
  static const mathLessonId = 'math-9-equations';
  static const lessonTitle = 'طرق الشحن الكهربائي';
  static const otherLessonTitle = 'القوة بين الشحنات الكهربائية';
  static const subjectName = 'العلوم والحياة';

  static const _pdfOffset = 4;
  static const _pdfFile = 'science-9.pdf';

  static Future<void> insert(ContentDatabase db) async {
    await db.batch((b) {
      b.insert(db.subjects,
          SubjectsCompanion.insert(id: subjectId, name: subjectName));
      b.insert(
        db.subjects,
        SubjectsCompanion.insert(
          id: mathSubjectId,
          name: 'الرياضيات',
          tutorEnabled: const Value(false),
          sortOrder: const Value(1),
        ),
      );
      b.insert(
          db.units,
          UnitsCompanion.insert(
              id: unitId, subjectId: subjectId, title: 'الكهرباء الساكنة'));
      b.insert(
        db.units,
        UnitsCompanion.insert(
            id: 'math-9-u1', subjectId: mathSubjectId, title: 'المعادلات'),
      );
      b.insert(db.lessons, _lesson(lessonId, lessonTitle, 12, 23, 0));
      b.insert(db.lessons, _lesson(otherLessonId, otherLessonTitle, 24, 27, 1));
      b.insert(
        db.lessons,
        LessonsCompanion.insert(
          id: mathLessonId,
          unitId: 'math-9-u1',
          subjectId: mathSubjectId,
          title: 'حل المعادلات',
          tutorEnabled: const Value(false),
        ),
      );
      b.insert(
        db.sections,
        SectionsCompanion.insert(
            lessonId: lessonId,
            title: 'الشحن بالدلك',
            body: chargingPassagesBasics[2].$2),
      );
      b.insert(
        db.keyTerms,
        KeyTermsCompanion.insert(
            lessonId: lessonId,
            term: 'الشحن بالحث',
            definition: 'شحن جسم دون ملامسة.'),
      );
      b.insert(
        db.questions,
        QuestionsCompanion.insert(
          lessonId: lessonId,
          type: 'mcq',
          question: 'أي الطرق التالية لا تحتاج إلى ملامسة؟',
          choicesJson: const Value('["الدلك","التماس","الحث"]'),
          answer: 'الحث',
        ),
      );
      b.insert(
        db.bookSolutions,
        BookSolutionsCompanion.insert(
            lessonId: lessonId, number: 1, page: 15, solution: 'الحث'),
      );
      for (final (kind, content) in chargingPrebuiltAnswers) {
        b.insert(
          db.prebuiltAnswers,
          PrebuiltAnswersCompanion.insert(
              lessonId: lessonId, kind: kind, content: content),
        );
      }
      b.insert(db.packMeta, PackMetaCompanion.insert(key: 'grade', value: '9'));
      b.insert(
          db.packMeta, PackMetaCompanion.insert(key: 'version', value: '1'));
    });
    await _insertPassages(db, lessonId, [
      ...chargingPassagesBasics,
      ...chargingPassagesInduction,
      chargingPassageLightning,
    ]);
    await _insertPassages(db, otherLessonId, forceLessonPassages);
    await db.batch((b) {
      for (final (question, answer, page) in chargingQuestionBank) {
        b.insert(
          db.questionBank,
          QuestionBankCompanion.insert(
            subjectId: subjectId,
            lessonId: lessonId,
            question: question,
            questionNormalized: ArabicNormalizer.normalize(question),
            answer: answer,
            printedPage: page,
          ),
        );
      }
    });
  }

  static LessonsCompanion _lesson(
          String id, String title, int from, int to, int order) =>
      LessonsCompanion.insert(
        id: id,
        unitId: unitId,
        subjectId: subjectId,
        title: title,
        sortOrder: Value(order),
        bookPagesFrom: Value(from),
        bookPagesTo: Value(to),
        pdfFile: const Value(_pdfFile),
      );

  static Future<void> _insertPassages(
    ContentDatabase db,
    String lesson,
    List<(String, String)> passages,
  ) async {
    await db.batch((b) {
      for (final (printedPage, text) in passages) {
        b.insert(
          db.chunks,
          ChunksCompanion.insert(
            lessonId: lesson,
            printedPage: printedPage,
            pdfPage: int.parse(printedPage) + _pdfOffset,
            content: text,
            textNormalized: ArabicNormalizer.normalize(text),
          ),
        );
      }
    });
  }
}
