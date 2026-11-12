// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_database.dart';

// ignore_for_file: type=lint
class $SavedAnswersTable extends SavedAnswers
    with TableInfo<$SavedAnswersTable, SavedAnswerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _subjectIdMeta =
      const VerificationMeta('subjectId');
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
      'subject_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourcePageMeta =
      const VerificationMeta('sourcePage');
  @override
  late final GeneratedColumn<int> sourcePage = GeneratedColumn<int>(
      'source_page', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, subjectId, lessonId, question, answer, sourcePage, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_answers';
  @override
  VerificationContext validateIntegrity(Insertable<SavedAnswerRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('source_page')) {
      context.handle(
          _sourcePageMeta,
          sourcePage.isAcceptableOrUnknown(
              data['source_page']!, _sourcePageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedAnswerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedAnswerRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      subjectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject_id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id']),
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer'])!,
      sourcePage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_page']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SavedAnswersTable createAlias(String alias) {
    return $SavedAnswersTable(attachedDatabase, alias);
  }
}

class SavedAnswerRow extends DataClass implements Insertable<SavedAnswerRow> {
  final int id;
  final String subjectId;
  final String? lessonId;
  final String question;
  final String answer;
  final int? sourcePage;
  final DateTime createdAt;
  const SavedAnswerRow(
      {required this.id,
      required this.subjectId,
      this.lessonId,
      required this.question,
      required this.answer,
      this.sourcePage,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subject_id'] = Variable<String>(subjectId);
    if (!nullToAbsent || lessonId != null) {
      map['lesson_id'] = Variable<String>(lessonId);
    }
    map['question'] = Variable<String>(question);
    map['answer'] = Variable<String>(answer);
    if (!nullToAbsent || sourcePage != null) {
      map['source_page'] = Variable<int>(sourcePage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavedAnswersCompanion toCompanion(bool nullToAbsent) {
    return SavedAnswersCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      lessonId: lessonId == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonId),
      question: Value(question),
      answer: Value(answer),
      sourcePage: sourcePage == null && nullToAbsent
          ? const Value.absent()
          : Value(sourcePage),
      createdAt: Value(createdAt),
    );
  }

  factory SavedAnswerRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedAnswerRow(
      id: serializer.fromJson<int>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      lessonId: serializer.fromJson<String?>(json['lessonId']),
      question: serializer.fromJson<String>(json['question']),
      answer: serializer.fromJson<String>(json['answer']),
      sourcePage: serializer.fromJson<int?>(json['sourcePage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'lessonId': serializer.toJson<String?>(lessonId),
      'question': serializer.toJson<String>(question),
      'answer': serializer.toJson<String>(answer),
      'sourcePage': serializer.toJson<int?>(sourcePage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SavedAnswerRow copyWith(
          {int? id,
          String? subjectId,
          Value<String?> lessonId = const Value.absent(),
          String? question,
          String? answer,
          Value<int?> sourcePage = const Value.absent(),
          DateTime? createdAt}) =>
      SavedAnswerRow(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        lessonId: lessonId.present ? lessonId.value : this.lessonId,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        sourcePage: sourcePage.present ? sourcePage.value : this.sourcePage,
        createdAt: createdAt ?? this.createdAt,
      );
  SavedAnswerRow copyWithCompanion(SavedAnswersCompanion data) {
    return SavedAnswerRow(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      question: data.question.present ? data.question.value : this.question,
      answer: data.answer.present ? data.answer.value : this.answer,
      sourcePage:
          data.sourcePage.present ? data.sourcePage.value : this.sourcePage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedAnswerRow(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('lessonId: $lessonId, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('sourcePage: $sourcePage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, subjectId, lessonId, question, answer, sourcePage, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedAnswerRow &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.lessonId == this.lessonId &&
          other.question == this.question &&
          other.answer == this.answer &&
          other.sourcePage == this.sourcePage &&
          other.createdAt == this.createdAt);
}

class SavedAnswersCompanion extends UpdateCompanion<SavedAnswerRow> {
  final Value<int> id;
  final Value<String> subjectId;
  final Value<String?> lessonId;
  final Value<String> question;
  final Value<String> answer;
  final Value<int?> sourcePage;
  final Value<DateTime> createdAt;
  const SavedAnswersCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.question = const Value.absent(),
    this.answer = const Value.absent(),
    this.sourcePage = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavedAnswersCompanion.insert({
    this.id = const Value.absent(),
    required String subjectId,
    this.lessonId = const Value.absent(),
    required String question,
    required String answer,
    this.sourcePage = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : subjectId = Value(subjectId),
        question = Value(question),
        answer = Value(answer);
  static Insertable<SavedAnswerRow> custom({
    Expression<int>? id,
    Expression<String>? subjectId,
    Expression<String>? lessonId,
    Expression<String>? question,
    Expression<String>? answer,
    Expression<int>? sourcePage,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (question != null) 'question': question,
      if (answer != null) 'answer': answer,
      if (sourcePage != null) 'source_page': sourcePage,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavedAnswersCompanion copyWith(
      {Value<int>? id,
      Value<String>? subjectId,
      Value<String?>? lessonId,
      Value<String>? question,
      Value<String>? answer,
      Value<int?>? sourcePage,
      Value<DateTime>? createdAt}) {
    return SavedAnswersCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      lessonId: lessonId ?? this.lessonId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      sourcePage: sourcePage ?? this.sourcePage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (sourcePage.present) {
      map['source_page'] = Variable<int>(sourcePage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedAnswersCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('lessonId: $lessonId, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('sourcePage: $sourcePage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $QuestionHistoryTable extends QuestionHistory
    with TableInfo<$QuestionHistoryTable, QuestionHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _subjectIdMeta =
      const VerificationMeta('subjectId');
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
      'subject_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, subjectId, lessonId, question, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_history';
  @override
  VerificationContext validateIntegrity(Insertable<QuestionHistoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionHistoryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      subjectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject_id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id']),
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $QuestionHistoryTable createAlias(String alias) {
    return $QuestionHistoryTable(attachedDatabase, alias);
  }
}

class QuestionHistoryRow extends DataClass
    implements Insertable<QuestionHistoryRow> {
  final int id;
  final String subjectId;
  final String? lessonId;
  final String question;
  final DateTime createdAt;
  const QuestionHistoryRow(
      {required this.id,
      required this.subjectId,
      this.lessonId,
      required this.question,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subject_id'] = Variable<String>(subjectId);
    if (!nullToAbsent || lessonId != null) {
      map['lesson_id'] = Variable<String>(lessonId);
    }
    map['question'] = Variable<String>(question);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  QuestionHistoryCompanion toCompanion(bool nullToAbsent) {
    return QuestionHistoryCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      lessonId: lessonId == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonId),
      question: Value(question),
      createdAt: Value(createdAt),
    );
  }

  factory QuestionHistoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionHistoryRow(
      id: serializer.fromJson<int>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      lessonId: serializer.fromJson<String?>(json['lessonId']),
      question: serializer.fromJson<String>(json['question']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'lessonId': serializer.toJson<String?>(lessonId),
      'question': serializer.toJson<String>(question),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  QuestionHistoryRow copyWith(
          {int? id,
          String? subjectId,
          Value<String?> lessonId = const Value.absent(),
          String? question,
          DateTime? createdAt}) =>
      QuestionHistoryRow(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        lessonId: lessonId.present ? lessonId.value : this.lessonId,
        question: question ?? this.question,
        createdAt: createdAt ?? this.createdAt,
      );
  QuestionHistoryRow copyWithCompanion(QuestionHistoryCompanion data) {
    return QuestionHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      question: data.question.present ? data.question.value : this.question,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionHistoryRow(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('lessonId: $lessonId, ')
          ..write('question: $question, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subjectId, lessonId, question, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionHistoryRow &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.lessonId == this.lessonId &&
          other.question == this.question &&
          other.createdAt == this.createdAt);
}

class QuestionHistoryCompanion extends UpdateCompanion<QuestionHistoryRow> {
  final Value<int> id;
  final Value<String> subjectId;
  final Value<String?> lessonId;
  final Value<String> question;
  final Value<DateTime> createdAt;
  const QuestionHistoryCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.question = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  QuestionHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String subjectId,
    this.lessonId = const Value.absent(),
    required String question,
    this.createdAt = const Value.absent(),
  })  : subjectId = Value(subjectId),
        question = Value(question);
  static Insertable<QuestionHistoryRow> custom({
    Expression<int>? id,
    Expression<String>? subjectId,
    Expression<String>? lessonId,
    Expression<String>? question,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (question != null) 'question': question,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  QuestionHistoryCompanion copyWith(
      {Value<int>? id,
      Value<String>? subjectId,
      Value<String?>? lessonId,
      Value<String>? question,
      Value<DateTime>? createdAt}) {
    return QuestionHistoryCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      lessonId: lessonId ?? this.lessonId,
      question: question ?? this.question,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionHistoryCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('lessonId: $lessonId, ')
          ..write('question: $question, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LessonProgressTable extends LessonProgress
    with TableInfo<$LessonProgressTable, LessonProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastSectionMeta =
      const VerificationMeta('lastSection');
  @override
  late final GeneratedColumn<int> lastSection = GeneratedColumn<int>(
      'last_section', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [lessonId, lastSection, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_progress';
  @override
  VerificationContext validateIntegrity(Insertable<LessonProgressRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('last_section')) {
      context.handle(
          _lastSectionMeta,
          lastSection.isAcceptableOrUnknown(
              data['last_section']!, _lastSectionMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonId};
  @override
  LessonProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonProgressRow(
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      lastSection: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_section'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LessonProgressTable createAlias(String alias) {
    return $LessonProgressTable(attachedDatabase, alias);
  }
}

class LessonProgressRow extends DataClass
    implements Insertable<LessonProgressRow> {
  final String lessonId;
  final int lastSection;
  final DateTime updatedAt;
  const LessonProgressRow(
      {required this.lessonId,
      required this.lastSection,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_id'] = Variable<String>(lessonId);
    map['last_section'] = Variable<int>(lastSection);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LessonProgressCompanion toCompanion(bool nullToAbsent) {
    return LessonProgressCompanion(
      lessonId: Value(lessonId),
      lastSection: Value(lastSection),
      updatedAt: Value(updatedAt),
    );
  }

  factory LessonProgressRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonProgressRow(
      lessonId: serializer.fromJson<String>(json['lessonId']),
      lastSection: serializer.fromJson<int>(json['lastSection']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lessonId': serializer.toJson<String>(lessonId),
      'lastSection': serializer.toJson<int>(lastSection),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LessonProgressRow copyWith(
          {String? lessonId, int? lastSection, DateTime? updatedAt}) =>
      LessonProgressRow(
        lessonId: lessonId ?? this.lessonId,
        lastSection: lastSection ?? this.lastSection,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LessonProgressRow copyWithCompanion(LessonProgressCompanion data) {
    return LessonProgressRow(
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      lastSection:
          data.lastSection.present ? data.lastSection.value : this.lastSection,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressRow(')
          ..write('lessonId: $lessonId, ')
          ..write('lastSection: $lastSection, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lessonId, lastSection, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonProgressRow &&
          other.lessonId == this.lessonId &&
          other.lastSection == this.lastSection &&
          other.updatedAt == this.updatedAt);
}

class LessonProgressCompanion extends UpdateCompanion<LessonProgressRow> {
  final Value<String> lessonId;
  final Value<int> lastSection;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LessonProgressCompanion({
    this.lessonId = const Value.absent(),
    this.lastSection = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonProgressCompanion.insert({
    required String lessonId,
    this.lastSection = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : lessonId = Value(lessonId);
  static Insertable<LessonProgressRow> custom({
    Expression<String>? lessonId,
    Expression<int>? lastSection,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonId != null) 'lesson_id': lessonId,
      if (lastSection != null) 'last_section': lastSection,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonProgressCompanion copyWith(
      {Value<String>? lessonId,
      Value<int>? lastSection,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LessonProgressCompanion(
      lessonId: lessonId ?? this.lessonId,
      lastSection: lastSection ?? this.lastSection,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (lastSection.present) {
      map['last_section'] = Variable<int>(lastSection.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressCompanion(')
          ..write('lessonId: $lessonId, ')
          ..write('lastSection: $lastSection, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingReportsTable extends PendingReports
    with TableInfo<$PendingReportsTable, PendingReportRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, lessonId, question, answer, reason, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_reports';
  @override
  VerificationContext validateIntegrity(Insertable<PendingReportRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingReportRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingReportRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id']),
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PendingReportsTable createAlias(String alias) {
    return $PendingReportsTable(attachedDatabase, alias);
  }
}

class PendingReportRow extends DataClass
    implements Insertable<PendingReportRow> {
  final int id;
  final String? lessonId;
  final String question;
  final String answer;
  final String reason;
  final String? note;
  final DateTime createdAt;
  const PendingReportRow(
      {required this.id,
      this.lessonId,
      required this.question,
      required this.answer,
      required this.reason,
      this.note,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lessonId != null) {
      map['lesson_id'] = Variable<String>(lessonId);
    }
    map['question'] = Variable<String>(question);
    map['answer'] = Variable<String>(answer);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingReportsCompanion toCompanion(bool nullToAbsent) {
    return PendingReportsCompanion(
      id: Value(id),
      lessonId: lessonId == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonId),
      question: Value(question),
      answer: Value(answer),
      reason: Value(reason),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory PendingReportRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingReportRow(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<String?>(json['lessonId']),
      question: serializer.fromJson<String>(json['question']),
      answer: serializer.fromJson<String>(json['answer']),
      reason: serializer.fromJson<String>(json['reason']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<String?>(lessonId),
      'question': serializer.toJson<String>(question),
      'answer': serializer.toJson<String>(answer),
      'reason': serializer.toJson<String>(reason),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingReportRow copyWith(
          {int? id,
          Value<String?> lessonId = const Value.absent(),
          String? question,
          String? answer,
          String? reason,
          Value<String?> note = const Value.absent(),
          DateTime? createdAt}) =>
      PendingReportRow(
        id: id ?? this.id,
        lessonId: lessonId.present ? lessonId.value : this.lessonId,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        reason: reason ?? this.reason,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
      );
  PendingReportRow copyWithCompanion(PendingReportsCompanion data) {
    return PendingReportRow(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      question: data.question.present ? data.question.value : this.question,
      answer: data.answer.present ? data.answer.value : this.answer,
      reason: data.reason.present ? data.reason.value : this.reason,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingReportRow(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lessonId, question, answer, reason, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingReportRow &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.question == this.question &&
          other.answer == this.answer &&
          other.reason == this.reason &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class PendingReportsCompanion extends UpdateCompanion<PendingReportRow> {
  final Value<int> id;
  final Value<String?> lessonId;
  final Value<String> question;
  final Value<String> answer;
  final Value<String> reason;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const PendingReportsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.question = const Value.absent(),
    this.answer = const Value.absent(),
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PendingReportsCompanion.insert({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    required String question,
    required String answer,
    required String reason,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : question = Value(question),
        answer = Value(answer),
        reason = Value(reason);
  static Insertable<PendingReportRow> custom({
    Expression<int>? id,
    Expression<String>? lessonId,
    Expression<String>? question,
    Expression<String>? answer,
    Expression<String>? reason,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (question != null) 'question': question,
      if (answer != null) 'answer': answer,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PendingReportsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? lessonId,
      Value<String>? question,
      Value<String>? answer,
      Value<String>? reason,
      Value<String?>? note,
      Value<DateTime>? createdAt}) {
    return PendingReportsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      reason: reason ?? this.reason,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingReportsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DownloadsStateTable extends DownloadsState
    with TableInfo<$DownloadsStateTable, DownloadStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadsStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _artifactMeta =
      const VerificationMeta('artifact');
  @override
  late final GeneratedColumn<String> artifact = GeneratedColumn<String>(
      'artifact', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _partIndexMeta =
      const VerificationMeta('partIndex');
  @override
  late final GeneratedColumn<int> partIndex = GeneratedColumn<int>(
      'part_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bytesDownloadedMeta =
      const VerificationMeta('bytesDownloaded');
  @override
  late final GeneratedColumn<int> bytesDownloaded = GeneratedColumn<int>(
      'bytes_downloaded', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalBytesMeta =
      const VerificationMeta('totalBytes');
  @override
  late final GeneratedColumn<int> totalBytes = GeneratedColumn<int>(
      'total_bytes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        artifact,
        partIndex,
        status,
        bytesDownloaded,
        totalBytes,
        taskId,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloads_state';
  @override
  VerificationContext validateIntegrity(Insertable<DownloadStateRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('artifact')) {
      context.handle(_artifactMeta,
          artifact.isAcceptableOrUnknown(data['artifact']!, _artifactMeta));
    } else if (isInserting) {
      context.missing(_artifactMeta);
    }
    if (data.containsKey('part_index')) {
      context.handle(_partIndexMeta,
          partIndex.isAcceptableOrUnknown(data['part_index']!, _partIndexMeta));
    } else if (isInserting) {
      context.missing(_partIndexMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('bytes_downloaded')) {
      context.handle(
          _bytesDownloadedMeta,
          bytesDownloaded.isAcceptableOrUnknown(
              data['bytes_downloaded']!, _bytesDownloadedMeta));
    }
    if (data.containsKey('total_bytes')) {
      context.handle(
          _totalBytesMeta,
          totalBytes.isAcceptableOrUnknown(
              data['total_bytes']!, _totalBytesMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadStateRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      artifact: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artifact'])!,
      partIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}part_index'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      bytesDownloaded: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bytes_downloaded'])!,
      totalBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_bytes'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DownloadsStateTable createAlias(String alias) {
    return $DownloadsStateTable(attachedDatabase, alias);
  }
}

class DownloadStateRow extends DataClass
    implements Insertable<DownloadStateRow> {
  final String id;
  final String artifact;
  final int partIndex;
  final String status;
  final int bytesDownloaded;
  final int totalBytes;
  final String? taskId;
  final DateTime updatedAt;
  const DownloadStateRow(
      {required this.id,
      required this.artifact,
      required this.partIndex,
      required this.status,
      required this.bytesDownloaded,
      required this.totalBytes,
      this.taskId,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['artifact'] = Variable<String>(artifact);
    map['part_index'] = Variable<int>(partIndex);
    map['status'] = Variable<String>(status);
    map['bytes_downloaded'] = Variable<int>(bytesDownloaded);
    map['total_bytes'] = Variable<int>(totalBytes);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DownloadsStateCompanion toCompanion(bool nullToAbsent) {
    return DownloadsStateCompanion(
      id: Value(id),
      artifact: Value(artifact),
      partIndex: Value(partIndex),
      status: Value(status),
      bytesDownloaded: Value(bytesDownloaded),
      totalBytes: Value(totalBytes),
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
      updatedAt: Value(updatedAt),
    );
  }

  factory DownloadStateRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadStateRow(
      id: serializer.fromJson<String>(json['id']),
      artifact: serializer.fromJson<String>(json['artifact']),
      partIndex: serializer.fromJson<int>(json['partIndex']),
      status: serializer.fromJson<String>(json['status']),
      bytesDownloaded: serializer.fromJson<int>(json['bytesDownloaded']),
      totalBytes: serializer.fromJson<int>(json['totalBytes']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'artifact': serializer.toJson<String>(artifact),
      'partIndex': serializer.toJson<int>(partIndex),
      'status': serializer.toJson<String>(status),
      'bytesDownloaded': serializer.toJson<int>(bytesDownloaded),
      'totalBytes': serializer.toJson<int>(totalBytes),
      'taskId': serializer.toJson<String?>(taskId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DownloadStateRow copyWith(
          {String? id,
          String? artifact,
          int? partIndex,
          String? status,
          int? bytesDownloaded,
          int? totalBytes,
          Value<String?> taskId = const Value.absent(),
          DateTime? updatedAt}) =>
      DownloadStateRow(
        id: id ?? this.id,
        artifact: artifact ?? this.artifact,
        partIndex: partIndex ?? this.partIndex,
        status: status ?? this.status,
        bytesDownloaded: bytesDownloaded ?? this.bytesDownloaded,
        totalBytes: totalBytes ?? this.totalBytes,
        taskId: taskId.present ? taskId.value : this.taskId,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DownloadStateRow copyWithCompanion(DownloadsStateCompanion data) {
    return DownloadStateRow(
      id: data.id.present ? data.id.value : this.id,
      artifact: data.artifact.present ? data.artifact.value : this.artifact,
      partIndex: data.partIndex.present ? data.partIndex.value : this.partIndex,
      status: data.status.present ? data.status.value : this.status,
      bytesDownloaded: data.bytesDownloaded.present
          ? data.bytesDownloaded.value
          : this.bytesDownloaded,
      totalBytes:
          data.totalBytes.present ? data.totalBytes.value : this.totalBytes,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadStateRow(')
          ..write('id: $id, ')
          ..write('artifact: $artifact, ')
          ..write('partIndex: $partIndex, ')
          ..write('status: $status, ')
          ..write('bytesDownloaded: $bytesDownloaded, ')
          ..write('totalBytes: $totalBytes, ')
          ..write('taskId: $taskId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, artifact, partIndex, status,
      bytesDownloaded, totalBytes, taskId, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadStateRow &&
          other.id == this.id &&
          other.artifact == this.artifact &&
          other.partIndex == this.partIndex &&
          other.status == this.status &&
          other.bytesDownloaded == this.bytesDownloaded &&
          other.totalBytes == this.totalBytes &&
          other.taskId == this.taskId &&
          other.updatedAt == this.updatedAt);
}

class DownloadsStateCompanion extends UpdateCompanion<DownloadStateRow> {
  final Value<String> id;
  final Value<String> artifact;
  final Value<int> partIndex;
  final Value<String> status;
  final Value<int> bytesDownloaded;
  final Value<int> totalBytes;
  final Value<String?> taskId;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DownloadsStateCompanion({
    this.id = const Value.absent(),
    this.artifact = const Value.absent(),
    this.partIndex = const Value.absent(),
    this.status = const Value.absent(),
    this.bytesDownloaded = const Value.absent(),
    this.totalBytes = const Value.absent(),
    this.taskId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DownloadsStateCompanion.insert({
    required String id,
    required String artifact,
    required int partIndex,
    required String status,
    this.bytesDownloaded = const Value.absent(),
    this.totalBytes = const Value.absent(),
    this.taskId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        artifact = Value(artifact),
        partIndex = Value(partIndex),
        status = Value(status);
  static Insertable<DownloadStateRow> custom({
    Expression<String>? id,
    Expression<String>? artifact,
    Expression<int>? partIndex,
    Expression<String>? status,
    Expression<int>? bytesDownloaded,
    Expression<int>? totalBytes,
    Expression<String>? taskId,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (artifact != null) 'artifact': artifact,
      if (partIndex != null) 'part_index': partIndex,
      if (status != null) 'status': status,
      if (bytesDownloaded != null) 'bytes_downloaded': bytesDownloaded,
      if (totalBytes != null) 'total_bytes': totalBytes,
      if (taskId != null) 'task_id': taskId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadsStateCompanion copyWith(
      {Value<String>? id,
      Value<String>? artifact,
      Value<int>? partIndex,
      Value<String>? status,
      Value<int>? bytesDownloaded,
      Value<int>? totalBytes,
      Value<String?>? taskId,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DownloadsStateCompanion(
      id: id ?? this.id,
      artifact: artifact ?? this.artifact,
      partIndex: partIndex ?? this.partIndex,
      status: status ?? this.status,
      bytesDownloaded: bytesDownloaded ?? this.bytesDownloaded,
      totalBytes: totalBytes ?? this.totalBytes,
      taskId: taskId ?? this.taskId,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (artifact.present) {
      map['artifact'] = Variable<String>(artifact.value);
    }
    if (partIndex.present) {
      map['part_index'] = Variable<int>(partIndex.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (bytesDownloaded.present) {
      map['bytes_downloaded'] = Variable<int>(bytesDownloaded.value);
    }
    if (totalBytes.present) {
      map['total_bytes'] = Variable<int>(totalBytes.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadsStateCompanion(')
          ..write('id: $id, ')
          ..write('artifact: $artifact, ')
          ..write('partIndex: $partIndex, ')
          ..write('status: $status, ')
          ..write('bytesDownloaded: $bytesDownloaded, ')
          ..write('totalBytes: $totalBytes, ')
          ..write('taskId: $taskId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$UserDatabase extends GeneratedDatabase {
  _$UserDatabase(QueryExecutor e) : super(e);
  $UserDatabaseManager get managers => $UserDatabaseManager(this);
  late final $SavedAnswersTable savedAnswers = $SavedAnswersTable(this);
  late final $QuestionHistoryTable questionHistory =
      $QuestionHistoryTable(this);
  late final $LessonProgressTable lessonProgress = $LessonProgressTable(this);
  late final $PendingReportsTable pendingReports = $PendingReportsTable(this);
  late final $DownloadsStateTable downloadsState = $DownloadsStateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        savedAnswers,
        questionHistory,
        lessonProgress,
        pendingReports,
        downloadsState
      ];
}

typedef $$SavedAnswersTableCreateCompanionBuilder = SavedAnswersCompanion
    Function({
  Value<int> id,
  required String subjectId,
  Value<String?> lessonId,
  required String question,
  required String answer,
  Value<int?> sourcePage,
  Value<DateTime> createdAt,
});
typedef $$SavedAnswersTableUpdateCompanionBuilder = SavedAnswersCompanion
    Function({
  Value<int> id,
  Value<String> subjectId,
  Value<String?> lessonId,
  Value<String> question,
  Value<String> answer,
  Value<int?> sourcePage,
  Value<DateTime> createdAt,
});

class $$SavedAnswersTableFilterComposer
    extends Composer<_$UserDatabase, $SavedAnswersTable> {
  $$SavedAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourcePage => $composableBuilder(
      column: $table.sourcePage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SavedAnswersTableOrderingComposer
    extends Composer<_$UserDatabase, $SavedAnswersTable> {
  $$SavedAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourcePage => $composableBuilder(
      column: $table.sourcePage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SavedAnswersTableAnnotationComposer
    extends Composer<_$UserDatabase, $SavedAnswersTable> {
  $$SavedAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<int> get sourcePage => $composableBuilder(
      column: $table.sourcePage, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavedAnswersTableTableManager extends RootTableManager<
    _$UserDatabase,
    $SavedAnswersTable,
    SavedAnswerRow,
    $$SavedAnswersTableFilterComposer,
    $$SavedAnswersTableOrderingComposer,
    $$SavedAnswersTableAnnotationComposer,
    $$SavedAnswersTableCreateCompanionBuilder,
    $$SavedAnswersTableUpdateCompanionBuilder,
    (
      SavedAnswerRow,
      BaseReferences<_$UserDatabase, $SavedAnswersTable, SavedAnswerRow>
    ),
    SavedAnswerRow,
    PrefetchHooks Function()> {
  $$SavedAnswersTableTableManager(_$UserDatabase db, $SavedAnswersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedAnswersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> subjectId = const Value.absent(),
            Value<String?> lessonId = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<String> answer = const Value.absent(),
            Value<int?> sourcePage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SavedAnswersCompanion(
            id: id,
            subjectId: subjectId,
            lessonId: lessonId,
            question: question,
            answer: answer,
            sourcePage: sourcePage,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String subjectId,
            Value<String?> lessonId = const Value.absent(),
            required String question,
            required String answer,
            Value<int?> sourcePage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SavedAnswersCompanion.insert(
            id: id,
            subjectId: subjectId,
            lessonId: lessonId,
            question: question,
            answer: answer,
            sourcePage: sourcePage,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SavedAnswersTable, SavedAnswerRow>(table),
                    BaseReferences<_$UserDatabase, $SavedAnswersTable,
                        SavedAnswerRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SavedAnswersTableProcessedTableManager = ProcessedTableManager<
    _$UserDatabase,
    $SavedAnswersTable,
    SavedAnswerRow,
    $$SavedAnswersTableFilterComposer,
    $$SavedAnswersTableOrderingComposer,
    $$SavedAnswersTableAnnotationComposer,
    $$SavedAnswersTableCreateCompanionBuilder,
    $$SavedAnswersTableUpdateCompanionBuilder,
    (
      SavedAnswerRow,
      BaseReferences<_$UserDatabase, $SavedAnswersTable, SavedAnswerRow>
    ),
    SavedAnswerRow,
    PrefetchHooks Function()>;
typedef $$QuestionHistoryTableCreateCompanionBuilder = QuestionHistoryCompanion
    Function({
  Value<int> id,
  required String subjectId,
  Value<String?> lessonId,
  required String question,
  Value<DateTime> createdAt,
});
typedef $$QuestionHistoryTableUpdateCompanionBuilder = QuestionHistoryCompanion
    Function({
  Value<int> id,
  Value<String> subjectId,
  Value<String?> lessonId,
  Value<String> question,
  Value<DateTime> createdAt,
});

class $$QuestionHistoryTableFilterComposer
    extends Composer<_$UserDatabase, $QuestionHistoryTable> {
  $$QuestionHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$QuestionHistoryTableOrderingComposer
    extends Composer<_$UserDatabase, $QuestionHistoryTable> {
  $$QuestionHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$QuestionHistoryTableAnnotationComposer
    extends Composer<_$UserDatabase, $QuestionHistoryTable> {
  $$QuestionHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$QuestionHistoryTableTableManager extends RootTableManager<
    _$UserDatabase,
    $QuestionHistoryTable,
    QuestionHistoryRow,
    $$QuestionHistoryTableFilterComposer,
    $$QuestionHistoryTableOrderingComposer,
    $$QuestionHistoryTableAnnotationComposer,
    $$QuestionHistoryTableCreateCompanionBuilder,
    $$QuestionHistoryTableUpdateCompanionBuilder,
    (
      QuestionHistoryRow,
      BaseReferences<_$UserDatabase, $QuestionHistoryTable, QuestionHistoryRow>
    ),
    QuestionHistoryRow,
    PrefetchHooks Function()> {
  $$QuestionHistoryTableTableManager(
      _$UserDatabase db, $QuestionHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> subjectId = const Value.absent(),
            Value<String?> lessonId = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              QuestionHistoryCompanion(
            id: id,
            subjectId: subjectId,
            lessonId: lessonId,
            question: question,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String subjectId,
            Value<String?> lessonId = const Value.absent(),
            required String question,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              QuestionHistoryCompanion.insert(
            id: id,
            subjectId: subjectId,
            lessonId: lessonId,
            question: question,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$QuestionHistoryTable, QuestionHistoryRow>(
                        table),
                    BaseReferences<_$UserDatabase, $QuestionHistoryTable,
                        QuestionHistoryRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuestionHistoryTableProcessedTableManager = ProcessedTableManager<
    _$UserDatabase,
    $QuestionHistoryTable,
    QuestionHistoryRow,
    $$QuestionHistoryTableFilterComposer,
    $$QuestionHistoryTableOrderingComposer,
    $$QuestionHistoryTableAnnotationComposer,
    $$QuestionHistoryTableCreateCompanionBuilder,
    $$QuestionHistoryTableUpdateCompanionBuilder,
    (
      QuestionHistoryRow,
      BaseReferences<_$UserDatabase, $QuestionHistoryTable, QuestionHistoryRow>
    ),
    QuestionHistoryRow,
    PrefetchHooks Function()>;
typedef $$LessonProgressTableCreateCompanionBuilder = LessonProgressCompanion
    Function({
  required String lessonId,
  Value<int> lastSection,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$LessonProgressTableUpdateCompanionBuilder = LessonProgressCompanion
    Function({
  Value<String> lessonId,
  Value<int> lastSection,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LessonProgressTableFilterComposer
    extends Composer<_$UserDatabase, $LessonProgressTable> {
  $$LessonProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastSection => $composableBuilder(
      column: $table.lastSection, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LessonProgressTableOrderingComposer
    extends Composer<_$UserDatabase, $LessonProgressTable> {
  $$LessonProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastSection => $composableBuilder(
      column: $table.lastSection, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LessonProgressTableAnnotationComposer
    extends Composer<_$UserDatabase, $LessonProgressTable> {
  $$LessonProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<int> get lastSection => $composableBuilder(
      column: $table.lastSection, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LessonProgressTableTableManager extends RootTableManager<
    _$UserDatabase,
    $LessonProgressTable,
    LessonProgressRow,
    $$LessonProgressTableFilterComposer,
    $$LessonProgressTableOrderingComposer,
    $$LessonProgressTableAnnotationComposer,
    $$LessonProgressTableCreateCompanionBuilder,
    $$LessonProgressTableUpdateCompanionBuilder,
    (
      LessonProgressRow,
      BaseReferences<_$UserDatabase, $LessonProgressTable, LessonProgressRow>
    ),
    LessonProgressRow,
    PrefetchHooks Function()> {
  $$LessonProgressTableTableManager(
      _$UserDatabase db, $LessonProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> lessonId = const Value.absent(),
            Value<int> lastSection = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonProgressCompanion(
            lessonId: lessonId,
            lastSection: lastSection,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String lessonId,
            Value<int> lastSection = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonProgressCompanion.insert(
            lessonId: lessonId,
            lastSection: lastSection,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LessonProgressTable, LessonProgressRow>(table),
                    BaseReferences<_$UserDatabase, $LessonProgressTable,
                        LessonProgressRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LessonProgressTableProcessedTableManager = ProcessedTableManager<
    _$UserDatabase,
    $LessonProgressTable,
    LessonProgressRow,
    $$LessonProgressTableFilterComposer,
    $$LessonProgressTableOrderingComposer,
    $$LessonProgressTableAnnotationComposer,
    $$LessonProgressTableCreateCompanionBuilder,
    $$LessonProgressTableUpdateCompanionBuilder,
    (
      LessonProgressRow,
      BaseReferences<_$UserDatabase, $LessonProgressTable, LessonProgressRow>
    ),
    LessonProgressRow,
    PrefetchHooks Function()>;
typedef $$PendingReportsTableCreateCompanionBuilder = PendingReportsCompanion
    Function({
  Value<int> id,
  Value<String?> lessonId,
  required String question,
  required String answer,
  required String reason,
  Value<String?> note,
  Value<DateTime> createdAt,
});
typedef $$PendingReportsTableUpdateCompanionBuilder = PendingReportsCompanion
    Function({
  Value<int> id,
  Value<String?> lessonId,
  Value<String> question,
  Value<String> answer,
  Value<String> reason,
  Value<String?> note,
  Value<DateTime> createdAt,
});

class $$PendingReportsTableFilterComposer
    extends Composer<_$UserDatabase, $PendingReportsTable> {
  $$PendingReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PendingReportsTableOrderingComposer
    extends Composer<_$UserDatabase, $PendingReportsTable> {
  $$PendingReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PendingReportsTableAnnotationComposer
    extends Composer<_$UserDatabase, $PendingReportsTable> {
  $$PendingReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingReportsTableTableManager extends RootTableManager<
    _$UserDatabase,
    $PendingReportsTable,
    PendingReportRow,
    $$PendingReportsTableFilterComposer,
    $$PendingReportsTableOrderingComposer,
    $$PendingReportsTableAnnotationComposer,
    $$PendingReportsTableCreateCompanionBuilder,
    $$PendingReportsTableUpdateCompanionBuilder,
    (
      PendingReportRow,
      BaseReferences<_$UserDatabase, $PendingReportsTable, PendingReportRow>
    ),
    PendingReportRow,
    PrefetchHooks Function()> {
  $$PendingReportsTableTableManager(
      _$UserDatabase db, $PendingReportsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> lessonId = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<String> answer = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PendingReportsCompanion(
            id: id,
            lessonId: lessonId,
            question: question,
            answer: answer,
            reason: reason,
            note: note,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> lessonId = const Value.absent(),
            required String question,
            required String answer,
            required String reason,
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PendingReportsCompanion.insert(
            id: id,
            lessonId: lessonId,
            question: question,
            answer: answer,
            reason: reason,
            note: note,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PendingReportsTable, PendingReportRow>(table),
                    BaseReferences<_$UserDatabase, $PendingReportsTable,
                        PendingReportRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PendingReportsTableProcessedTableManager = ProcessedTableManager<
    _$UserDatabase,
    $PendingReportsTable,
    PendingReportRow,
    $$PendingReportsTableFilterComposer,
    $$PendingReportsTableOrderingComposer,
    $$PendingReportsTableAnnotationComposer,
    $$PendingReportsTableCreateCompanionBuilder,
    $$PendingReportsTableUpdateCompanionBuilder,
    (
      PendingReportRow,
      BaseReferences<_$UserDatabase, $PendingReportsTable, PendingReportRow>
    ),
    PendingReportRow,
    PrefetchHooks Function()>;
typedef $$DownloadsStateTableCreateCompanionBuilder = DownloadsStateCompanion
    Function({
  required String id,
  required String artifact,
  required int partIndex,
  required String status,
  Value<int> bytesDownloaded,
  Value<int> totalBytes,
  Value<String?> taskId,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$DownloadsStateTableUpdateCompanionBuilder = DownloadsStateCompanion
    Function({
  Value<String> id,
  Value<String> artifact,
  Value<int> partIndex,
  Value<String> status,
  Value<int> bytesDownloaded,
  Value<int> totalBytes,
  Value<String?> taskId,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DownloadsStateTableFilterComposer
    extends Composer<_$UserDatabase, $DownloadsStateTable> {
  $$DownloadsStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artifact => $composableBuilder(
      column: $table.artifact, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get partIndex => $composableBuilder(
      column: $table.partIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bytesDownloaded => $composableBuilder(
      column: $table.bytesDownloaded,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalBytes => $composableBuilder(
      column: $table.totalBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DownloadsStateTableOrderingComposer
    extends Composer<_$UserDatabase, $DownloadsStateTable> {
  $$DownloadsStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artifact => $composableBuilder(
      column: $table.artifact, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get partIndex => $composableBuilder(
      column: $table.partIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bytesDownloaded => $composableBuilder(
      column: $table.bytesDownloaded,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalBytes => $composableBuilder(
      column: $table.totalBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DownloadsStateTableAnnotationComposer
    extends Composer<_$UserDatabase, $DownloadsStateTable> {
  $$DownloadsStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get artifact =>
      $composableBuilder(column: $table.artifact, builder: (column) => column);

  GeneratedColumn<int> get partIndex =>
      $composableBuilder(column: $table.partIndex, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get bytesDownloaded => $composableBuilder(
      column: $table.bytesDownloaded, builder: (column) => column);

  GeneratedColumn<int> get totalBytes => $composableBuilder(
      column: $table.totalBytes, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DownloadsStateTableTableManager extends RootTableManager<
    _$UserDatabase,
    $DownloadsStateTable,
    DownloadStateRow,
    $$DownloadsStateTableFilterComposer,
    $$DownloadsStateTableOrderingComposer,
    $$DownloadsStateTableAnnotationComposer,
    $$DownloadsStateTableCreateCompanionBuilder,
    $$DownloadsStateTableUpdateCompanionBuilder,
    (
      DownloadStateRow,
      BaseReferences<_$UserDatabase, $DownloadsStateTable, DownloadStateRow>
    ),
    DownloadStateRow,
    PrefetchHooks Function()> {
  $$DownloadsStateTableTableManager(
      _$UserDatabase db, $DownloadsStateTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadsStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadsStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadsStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> artifact = const Value.absent(),
            Value<int> partIndex = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> bytesDownloaded = const Value.absent(),
            Value<int> totalBytes = const Value.absent(),
            Value<String?> taskId = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadsStateCompanion(
            id: id,
            artifact: artifact,
            partIndex: partIndex,
            status: status,
            bytesDownloaded: bytesDownloaded,
            totalBytes: totalBytes,
            taskId: taskId,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String artifact,
            required int partIndex,
            required String status,
            Value<int> bytesDownloaded = const Value.absent(),
            Value<int> totalBytes = const Value.absent(),
            Value<String?> taskId = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadsStateCompanion.insert(
            id: id,
            artifact: artifact,
            partIndex: partIndex,
            status: status,
            bytesDownloaded: bytesDownloaded,
            totalBytes: totalBytes,
            taskId: taskId,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DownloadsStateTable, DownloadStateRow>(table),
                    BaseReferences<_$UserDatabase, $DownloadsStateTable,
                        DownloadStateRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DownloadsStateTableProcessedTableManager = ProcessedTableManager<
    _$UserDatabase,
    $DownloadsStateTable,
    DownloadStateRow,
    $$DownloadsStateTableFilterComposer,
    $$DownloadsStateTableOrderingComposer,
    $$DownloadsStateTableAnnotationComposer,
    $$DownloadsStateTableCreateCompanionBuilder,
    $$DownloadsStateTableUpdateCompanionBuilder,
    (
      DownloadStateRow,
      BaseReferences<_$UserDatabase, $DownloadsStateTable, DownloadStateRow>
    ),
    DownloadStateRow,
    PrefetchHooks Function()>;

class $UserDatabaseManager {
  final _$UserDatabase _db;
  $UserDatabaseManager(this._db);
  $$SavedAnswersTableTableManager get savedAnswers =>
      $$SavedAnswersTableTableManager(_db, _db.savedAnswers);
  $$QuestionHistoryTableTableManager get questionHistory =>
      $$QuestionHistoryTableTableManager(_db, _db.questionHistory);
  $$LessonProgressTableTableManager get lessonProgress =>
      $$LessonProgressTableTableManager(_db, _db.lessonProgress);
  $$PendingReportsTableTableManager get pendingReports =>
      $$PendingReportsTableTableManager(_db, _db.pendingReports);
  $$DownloadsStateTableTableManager get downloadsState =>
      $$DownloadsStateTableTableManager(_db, _db.downloadsState);
}
