import 'package:drift/drift.dart';

import '../../utils/arabic_normalizer.dart';
import '../../utils/vector_codec.dart';
import 'content_database.dart';

/// Small fixture: one grade-9 science lesson. Used by tests and dev builds only.
abstract final class ContentSeed {
  static const subjectId = 'science';
  static const lessonId = 'science-9-charging';

  static const _chunks = <(int, String, List<double>)>[
    (12, 'الشحن بالدلك: عند دلك جسمين مختلفين ينتقل بعض الإلكترونات من جسم إلى آخر فيكتسب كل منهما شحنة.', [1, 0, 0]),
    (13, 'الشحن بالتماس: يكتسب الجسم المتعادل شحنة من نفس نوع شحنة الجسم المشحون الذي يلامسه.', [0, 1, 0]),
    (14, 'الشحن بالحث: يُشحن الجسم دون ملامسة عند تقريب جسم مشحون منه ثم توصيله بالأرض.', [0, 0, 1]),
  ];

  static Future<void> insert(ContentDatabase db) async {
    await db.batch((b) {
      b.insert(db.subjects,
          SubjectsCompanion.insert(id: subjectId, name: 'العلوم والحياة'));
      b.insert(db.units,
          UnitsCompanion.insert(id: 'science-9-u1', subjectId: subjectId, title: 'الكهرباء الساكنة'));
      b.insert(
          db.lessons,
          LessonsCompanion.insert(
            id: lessonId,
            unitId: 'science-9-u1',
            subjectId: subjectId,
            title: 'طرق الشحن الكهربائي',
            bookPagesFrom: const Value(12),
            bookPagesTo: const Value(14),
            pdfFile: const Value('science-9.pdf'),
          ));
      b.insert(db.sections,
          SectionsCompanion.insert(lessonId: lessonId, title: 'الشحن بالدلك', body: _chunks[0].$2));
      b.insert(db.keyTerms,
          KeyTermsCompanion.insert(lessonId: lessonId, term: 'الشحن بالحث', definition: 'شحن جسم دون ملامسة.'));
      b.insert(
          db.questions,
          QuestionsCompanion.insert(
            lessonId: lessonId,
            type: 'mcq',
            question: 'أي الطرق التالية لا تحتاج إلى ملامسة؟',
            choicesJson: const Value('["الدلك","التماس","الحث"]'),
            answer: 'الحث',
          ));
      b.insert(db.bookSolutions,
          BookSolutionsCompanion.insert(lessonId: lessonId, number: 1, page: 15, solution: 'الحث'));
      b.insert(db.prebuiltAnswers,
          PrebuiltAnswersCompanion.insert(lessonId: lessonId, kind: 'summary', content: 'ثلاث طرق للشحن: الدلك والتماس والحث.'));
      b.insert(db.packMeta, PackMetaCompanion.insert(key: 'grade', value: '9'));
      b.insert(db.packMeta, PackMetaCompanion.insert(key: 'version', value: '1'));
    });
    for (final (page, text, vector) in _chunks) {
      final id = await db.into(db.chunks).insert(ChunksCompanion.insert(
            lessonId: lessonId,
            page: page,
            content: text,
            textNormalized: ArabicNormalizer.normalize(text),
          ));
      await db.into(db.chunkVectors).insert(
          ChunkVectorsCompanion.insert(chunkId: Value(id), vector: VectorCodec.encode(vector)));
    }
  }
}
