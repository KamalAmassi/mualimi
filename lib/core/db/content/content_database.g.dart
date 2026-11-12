// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_database.dart';

// ignore_for_file: type=lint
class $SubjectsTable extends Subjects
    with TableInfo<$SubjectsTable, SubjectRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tutorEnabledMeta =
      const VerificationMeta('tutorEnabled');
  @override
  late final GeneratedColumn<bool> tutorEnabled = GeneratedColumn<bool>(
      'tutor_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("tutor_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, tutorEnabled, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(Insertable<SubjectRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('tutor_enabled')) {
      context.handle(
          _tutorEnabledMeta,
          tutorEnabled.isAcceptableOrUnknown(
              data['tutor_enabled']!, _tutorEnabledMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubjectRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubjectRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      tutorEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}tutor_enabled'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class SubjectRow extends DataClass implements Insertable<SubjectRow> {
  final String id;
  final String name;
  final bool tutorEnabled;
  final int sortOrder;
  const SubjectRow(
      {required this.id,
      required this.name,
      required this.tutorEnabled,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['tutor_enabled'] = Variable<bool>(tutorEnabled);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      name: Value(name),
      tutorEnabled: Value(tutorEnabled),
      sortOrder: Value(sortOrder),
    );
  }

  factory SubjectRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubjectRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      tutorEnabled: serializer.fromJson<bool>(json['tutorEnabled']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'tutorEnabled': serializer.toJson<bool>(tutorEnabled),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  SubjectRow copyWith(
          {String? id, String? name, bool? tutorEnabled, int? sortOrder}) =>
      SubjectRow(
        id: id ?? this.id,
        name: name ?? this.name,
        tutorEnabled: tutorEnabled ?? this.tutorEnabled,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  SubjectRow copyWithCompanion(SubjectsCompanion data) {
    return SubjectRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      tutorEnabled: data.tutorEnabled.present
          ? data.tutorEnabled.value
          : this.tutorEnabled,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubjectRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('tutorEnabled: $tutorEnabled, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, tutorEnabled, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.tutorEnabled == this.tutorEnabled &&
          other.sortOrder == this.sortOrder);
}

class SubjectsCompanion extends UpdateCompanion<SubjectRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> tutorEnabled;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.tutorEnabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsCompanion.insert({
    required String id,
    required String name,
    this.tutorEnabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<SubjectRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? tutorEnabled,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (tutorEnabled != null) 'tutor_enabled': tutorEnabled,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<bool>? tutorEnabled,
      Value<int>? sortOrder,
      Value<int>? rowid}) {
    return SubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      tutorEnabled: tutorEnabled ?? this.tutorEnabled,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (tutorEnabled.present) {
      map['tutor_enabled'] = Variable<bool>(tutorEnabled.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('tutorEnabled: $tutorEnabled, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, UnitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subjectIdMeta =
      const VerificationMeta('subjectId');
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
      'subject_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, subjectId, title, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(Insertable<UnitRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      subjectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class UnitRow extends DataClass implements Insertable<UnitRow> {
  final String id;
  final String subjectId;
  final String title;
  final int sortOrder;
  const UnitRow(
      {required this.id,
      required this.subjectId,
      required this.title,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    map['title'] = Variable<String>(title);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      title: Value(title),
      sortOrder: Value(sortOrder),
    );
  }

  factory UnitRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitRow(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      title: serializer.fromJson<String>(json['title']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'title': serializer.toJson<String>(title),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  UnitRow copyWith(
          {String? id, String? subjectId, String? title, int? sortOrder}) =>
      UnitRow(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        title: title ?? this.title,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  UnitRow copyWithCompanion(UnitsCompanion data) {
    return UnitRow(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      title: data.title.present ? data.title.value : this.title,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitRow(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subjectId, title, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitRow &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.title == this.title &&
          other.sortOrder == this.sortOrder);
}

class UnitsCompanion extends UpdateCompanion<UnitRow> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> title;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.title = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitsCompanion.insert({
    required String id,
    required String subjectId,
    required String title,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        subjectId = Value(subjectId),
        title = Value(title);
  static Insertable<UnitRow> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? title,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (title != null) 'title': title,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitsCompanion copyWith(
      {Value<String>? id,
      Value<String>? subjectId,
      Value<String>? title,
      Value<int>? sortOrder,
      Value<int>? rowid}) {
    return UnitsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonsTable extends Lessons with TableInfo<$LessonsTable, LessonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
      'unit_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subjectIdMeta =
      const VerificationMeta('subjectId');
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
      'subject_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _videoUrlMeta =
      const VerificationMeta('videoUrl');
  @override
  late final GeneratedColumn<String> videoUrl = GeneratedColumn<String>(
      'video_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _videoChaptersJsonMeta =
      const VerificationMeta('videoChaptersJson');
  @override
  late final GeneratedColumn<String> videoChaptersJson =
      GeneratedColumn<String>('video_chapters_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bookPagesFromMeta =
      const VerificationMeta('bookPagesFrom');
  @override
  late final GeneratedColumn<int> bookPagesFrom = GeneratedColumn<int>(
      'book_pages_from', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bookPagesToMeta =
      const VerificationMeta('bookPagesTo');
  @override
  late final GeneratedColumn<int> bookPagesTo = GeneratedColumn<int>(
      'book_pages_to', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pdfFileMeta =
      const VerificationMeta('pdfFile');
  @override
  late final GeneratedColumn<String> pdfFile = GeneratedColumn<String>(
      'pdf_file', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tutorEnabledMeta =
      const VerificationMeta('tutorEnabled');
  @override
  late final GeneratedColumn<bool> tutorEnabled = GeneratedColumn<bool>(
      'tutor_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("tutor_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        unitId,
        subjectId,
        title,
        sortOrder,
        videoUrl,
        videoChaptersJson,
        bookPagesFrom,
        bookPagesTo,
        pdfFile,
        tutorEnabled
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(Insertable<LessonRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('video_url')) {
      context.handle(_videoUrlMeta,
          videoUrl.isAcceptableOrUnknown(data['video_url']!, _videoUrlMeta));
    }
    if (data.containsKey('video_chapters_json')) {
      context.handle(
          _videoChaptersJsonMeta,
          videoChaptersJson.isAcceptableOrUnknown(
              data['video_chapters_json']!, _videoChaptersJsonMeta));
    }
    if (data.containsKey('book_pages_from')) {
      context.handle(
          _bookPagesFromMeta,
          bookPagesFrom.isAcceptableOrUnknown(
              data['book_pages_from']!, _bookPagesFromMeta));
    }
    if (data.containsKey('book_pages_to')) {
      context.handle(
          _bookPagesToMeta,
          bookPagesTo.isAcceptableOrUnknown(
              data['book_pages_to']!, _bookPagesToMeta));
    }
    if (data.containsKey('pdf_file')) {
      context.handle(_pdfFileMeta,
          pdfFile.isAcceptableOrUnknown(data['pdf_file']!, _pdfFileMeta));
    }
    if (data.containsKey('tutor_enabled')) {
      context.handle(
          _tutorEnabledMeta,
          tutorEnabled.isAcceptableOrUnknown(
              data['tutor_enabled']!, _tutorEnabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_id'])!,
      subjectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      videoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}video_url']),
      videoChaptersJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}video_chapters_json']),
      bookPagesFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}book_pages_from']),
      bookPagesTo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}book_pages_to']),
      pdfFile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pdf_file']),
      tutorEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}tutor_enabled'])!,
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class LessonRow extends DataClass implements Insertable<LessonRow> {
  final String id;
  final String unitId;
  final String subjectId;
  final String title;
  final int sortOrder;
  final String? videoUrl;
  final String? videoChaptersJson;
  final int? bookPagesFrom;
  final int? bookPagesTo;
  final String? pdfFile;
  final bool tutorEnabled;
  const LessonRow(
      {required this.id,
      required this.unitId,
      required this.subjectId,
      required this.title,
      required this.sortOrder,
      this.videoUrl,
      this.videoChaptersJson,
      this.bookPagesFrom,
      this.bookPagesTo,
      this.pdfFile,
      required this.tutorEnabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['unit_id'] = Variable<String>(unitId);
    map['subject_id'] = Variable<String>(subjectId);
    map['title'] = Variable<String>(title);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || videoUrl != null) {
      map['video_url'] = Variable<String>(videoUrl);
    }
    if (!nullToAbsent || videoChaptersJson != null) {
      map['video_chapters_json'] = Variable<String>(videoChaptersJson);
    }
    if (!nullToAbsent || bookPagesFrom != null) {
      map['book_pages_from'] = Variable<int>(bookPagesFrom);
    }
    if (!nullToAbsent || bookPagesTo != null) {
      map['book_pages_to'] = Variable<int>(bookPagesTo);
    }
    if (!nullToAbsent || pdfFile != null) {
      map['pdf_file'] = Variable<String>(pdfFile);
    }
    map['tutor_enabled'] = Variable<bool>(tutorEnabled);
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      unitId: Value(unitId),
      subjectId: Value(subjectId),
      title: Value(title),
      sortOrder: Value(sortOrder),
      videoUrl: videoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(videoUrl),
      videoChaptersJson: videoChaptersJson == null && nullToAbsent
          ? const Value.absent()
          : Value(videoChaptersJson),
      bookPagesFrom: bookPagesFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(bookPagesFrom),
      bookPagesTo: bookPagesTo == null && nullToAbsent
          ? const Value.absent()
          : Value(bookPagesTo),
      pdfFile: pdfFile == null && nullToAbsent
          ? const Value.absent()
          : Value(pdfFile),
      tutorEnabled: Value(tutorEnabled),
    );
  }

  factory LessonRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonRow(
      id: serializer.fromJson<String>(json['id']),
      unitId: serializer.fromJson<String>(json['unitId']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      title: serializer.fromJson<String>(json['title']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      videoUrl: serializer.fromJson<String?>(json['videoUrl']),
      videoChaptersJson:
          serializer.fromJson<String?>(json['videoChaptersJson']),
      bookPagesFrom: serializer.fromJson<int?>(json['bookPagesFrom']),
      bookPagesTo: serializer.fromJson<int?>(json['bookPagesTo']),
      pdfFile: serializer.fromJson<String?>(json['pdfFile']),
      tutorEnabled: serializer.fromJson<bool>(json['tutorEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'unitId': serializer.toJson<String>(unitId),
      'subjectId': serializer.toJson<String>(subjectId),
      'title': serializer.toJson<String>(title),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'videoUrl': serializer.toJson<String?>(videoUrl),
      'videoChaptersJson': serializer.toJson<String?>(videoChaptersJson),
      'bookPagesFrom': serializer.toJson<int?>(bookPagesFrom),
      'bookPagesTo': serializer.toJson<int?>(bookPagesTo),
      'pdfFile': serializer.toJson<String?>(pdfFile),
      'tutorEnabled': serializer.toJson<bool>(tutorEnabled),
    };
  }

  LessonRow copyWith(
          {String? id,
          String? unitId,
          String? subjectId,
          String? title,
          int? sortOrder,
          Value<String?> videoUrl = const Value.absent(),
          Value<String?> videoChaptersJson = const Value.absent(),
          Value<int?> bookPagesFrom = const Value.absent(),
          Value<int?> bookPagesTo = const Value.absent(),
          Value<String?> pdfFile = const Value.absent(),
          bool? tutorEnabled}) =>
      LessonRow(
        id: id ?? this.id,
        unitId: unitId ?? this.unitId,
        subjectId: subjectId ?? this.subjectId,
        title: title ?? this.title,
        sortOrder: sortOrder ?? this.sortOrder,
        videoUrl: videoUrl.present ? videoUrl.value : this.videoUrl,
        videoChaptersJson: videoChaptersJson.present
            ? videoChaptersJson.value
            : this.videoChaptersJson,
        bookPagesFrom:
            bookPagesFrom.present ? bookPagesFrom.value : this.bookPagesFrom,
        bookPagesTo: bookPagesTo.present ? bookPagesTo.value : this.bookPagesTo,
        pdfFile: pdfFile.present ? pdfFile.value : this.pdfFile,
        tutorEnabled: tutorEnabled ?? this.tutorEnabled,
      );
  LessonRow copyWithCompanion(LessonsCompanion data) {
    return LessonRow(
      id: data.id.present ? data.id.value : this.id,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      title: data.title.present ? data.title.value : this.title,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      videoUrl: data.videoUrl.present ? data.videoUrl.value : this.videoUrl,
      videoChaptersJson: data.videoChaptersJson.present
          ? data.videoChaptersJson.value
          : this.videoChaptersJson,
      bookPagesFrom: data.bookPagesFrom.present
          ? data.bookPagesFrom.value
          : this.bookPagesFrom,
      bookPagesTo:
          data.bookPagesTo.present ? data.bookPagesTo.value : this.bookPagesTo,
      pdfFile: data.pdfFile.present ? data.pdfFile.value : this.pdfFile,
      tutorEnabled: data.tutorEnabled.present
          ? data.tutorEnabled.value
          : this.tutorEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonRow(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('videoChaptersJson: $videoChaptersJson, ')
          ..write('bookPagesFrom: $bookPagesFrom, ')
          ..write('bookPagesTo: $bookPagesTo, ')
          ..write('pdfFile: $pdfFile, ')
          ..write('tutorEnabled: $tutorEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      unitId,
      subjectId,
      title,
      sortOrder,
      videoUrl,
      videoChaptersJson,
      bookPagesFrom,
      bookPagesTo,
      pdfFile,
      tutorEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonRow &&
          other.id == this.id &&
          other.unitId == this.unitId &&
          other.subjectId == this.subjectId &&
          other.title == this.title &&
          other.sortOrder == this.sortOrder &&
          other.videoUrl == this.videoUrl &&
          other.videoChaptersJson == this.videoChaptersJson &&
          other.bookPagesFrom == this.bookPagesFrom &&
          other.bookPagesTo == this.bookPagesTo &&
          other.pdfFile == this.pdfFile &&
          other.tutorEnabled == this.tutorEnabled);
}

class LessonsCompanion extends UpdateCompanion<LessonRow> {
  final Value<String> id;
  final Value<String> unitId;
  final Value<String> subjectId;
  final Value<String> title;
  final Value<int> sortOrder;
  final Value<String?> videoUrl;
  final Value<String?> videoChaptersJson;
  final Value<int?> bookPagesFrom;
  final Value<int?> bookPagesTo;
  final Value<String?> pdfFile;
  final Value<bool> tutorEnabled;
  final Value<int> rowid;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.unitId = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.title = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.videoChaptersJson = const Value.absent(),
    this.bookPagesFrom = const Value.absent(),
    this.bookPagesTo = const Value.absent(),
    this.pdfFile = const Value.absent(),
    this.tutorEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonsCompanion.insert({
    required String id,
    required String unitId,
    required String subjectId,
    required String title,
    this.sortOrder = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.videoChaptersJson = const Value.absent(),
    this.bookPagesFrom = const Value.absent(),
    this.bookPagesTo = const Value.absent(),
    this.pdfFile = const Value.absent(),
    this.tutorEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        unitId = Value(unitId),
        subjectId = Value(subjectId),
        title = Value(title);
  static Insertable<LessonRow> custom({
    Expression<String>? id,
    Expression<String>? unitId,
    Expression<String>? subjectId,
    Expression<String>? title,
    Expression<int>? sortOrder,
    Expression<String>? videoUrl,
    Expression<String>? videoChaptersJson,
    Expression<int>? bookPagesFrom,
    Expression<int>? bookPagesTo,
    Expression<String>? pdfFile,
    Expression<bool>? tutorEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unitId != null) 'unit_id': unitId,
      if (subjectId != null) 'subject_id': subjectId,
      if (title != null) 'title': title,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (videoUrl != null) 'video_url': videoUrl,
      if (videoChaptersJson != null) 'video_chapters_json': videoChaptersJson,
      if (bookPagesFrom != null) 'book_pages_from': bookPagesFrom,
      if (bookPagesTo != null) 'book_pages_to': bookPagesTo,
      if (pdfFile != null) 'pdf_file': pdfFile,
      if (tutorEnabled != null) 'tutor_enabled': tutorEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonsCompanion copyWith(
      {Value<String>? id,
      Value<String>? unitId,
      Value<String>? subjectId,
      Value<String>? title,
      Value<int>? sortOrder,
      Value<String?>? videoUrl,
      Value<String?>? videoChaptersJson,
      Value<int?>? bookPagesFrom,
      Value<int?>? bookPagesTo,
      Value<String?>? pdfFile,
      Value<bool>? tutorEnabled,
      Value<int>? rowid}) {
    return LessonsCompanion(
      id: id ?? this.id,
      unitId: unitId ?? this.unitId,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      sortOrder: sortOrder ?? this.sortOrder,
      videoUrl: videoUrl ?? this.videoUrl,
      videoChaptersJson: videoChaptersJson ?? this.videoChaptersJson,
      bookPagesFrom: bookPagesFrom ?? this.bookPagesFrom,
      bookPagesTo: bookPagesTo ?? this.bookPagesTo,
      pdfFile: pdfFile ?? this.pdfFile,
      tutorEnabled: tutorEnabled ?? this.tutorEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (videoUrl.present) {
      map['video_url'] = Variable<String>(videoUrl.value);
    }
    if (videoChaptersJson.present) {
      map['video_chapters_json'] = Variable<String>(videoChaptersJson.value);
    }
    if (bookPagesFrom.present) {
      map['book_pages_from'] = Variable<int>(bookPagesFrom.value);
    }
    if (bookPagesTo.present) {
      map['book_pages_to'] = Variable<int>(bookPagesTo.value);
    }
    if (pdfFile.present) {
      map['pdf_file'] = Variable<String>(pdfFile.value);
    }
    if (tutorEnabled.present) {
      map['tutor_enabled'] = Variable<bool>(tutorEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('videoChaptersJson: $videoChaptersJson, ')
          ..write('bookPagesFrom: $bookPagesFrom, ')
          ..write('bookPagesTo: $bookPagesTo, ')
          ..write('pdfFile: $pdfFile, ')
          ..write('tutorEnabled: $tutorEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SectionsTable extends Sections
    with TableInfo<$SectionsTable, SectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SectionsTable(this.attachedDatabase, [this._alias]);
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
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, lessonId, title, body, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sections';
  @override
  VerificationContext validateIntegrity(Insertable<SectionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SectionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $SectionsTable createAlias(String alias) {
    return $SectionsTable(attachedDatabase, alias);
  }
}

class SectionRow extends DataClass implements Insertable<SectionRow> {
  final int id;
  final String lessonId;
  final String title;
  final String body;
  final int sortOrder;
  const SectionRow(
      {required this.id,
      required this.lessonId,
      required this.title,
      required this.body,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SectionsCompanion toCompanion(bool nullToAbsent) {
    return SectionsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      title: Value(title),
      body: Value(body),
      sortOrder: Value(sortOrder),
    );
  }

  factory SectionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SectionRow(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  SectionRow copyWith(
          {int? id,
          String? lessonId,
          String? title,
          String? body,
          int? sortOrder}) =>
      SectionRow(
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        title: title ?? this.title,
        body: body ?? this.body,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  SectionRow copyWithCompanion(SectionsCompanion data) {
    return SectionRow(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SectionRow(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lessonId, title, body, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SectionRow &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.title == this.title &&
          other.body == this.body &&
          other.sortOrder == this.sortOrder);
}

class SectionsCompanion extends UpdateCompanion<SectionRow> {
  final Value<int> id;
  final Value<String> lessonId;
  final Value<String> title;
  final Value<String> body;
  final Value<int> sortOrder;
  const SectionsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  SectionsCompanion.insert({
    this.id = const Value.absent(),
    required String lessonId,
    required String title,
    required String body,
    this.sortOrder = const Value.absent(),
  })  : lessonId = Value(lessonId),
        title = Value(title),
        body = Value(body);
  static Insertable<SectionRow> custom({
    Expression<int>? id,
    Expression<String>? lessonId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  SectionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? lessonId,
      Value<String>? title,
      Value<String>? body,
      Value<int>? sortOrder}) {
    return SectionsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      title: title ?? this.title,
      body: body ?? this.body,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SectionsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $KeyTermsTable extends KeyTerms
    with TableInfo<$KeyTermsTable, KeyTermRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeyTermsTable(this.attachedDatabase, [this._alias]);
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
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _termMeta = const VerificationMeta('term');
  @override
  late final GeneratedColumn<String> term = GeneratedColumn<String>(
      'term', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _definitionMeta =
      const VerificationMeta('definition');
  @override
  late final GeneratedColumn<String> definition = GeneratedColumn<String>(
      'definition', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, lessonId, term, definition];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'key_terms';
  @override
  VerificationContext validateIntegrity(Insertable<KeyTermRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('term')) {
      context.handle(
          _termMeta, term.isAcceptableOrUnknown(data['term']!, _termMeta));
    } else if (isInserting) {
      context.missing(_termMeta);
    }
    if (data.containsKey('definition')) {
      context.handle(
          _definitionMeta,
          definition.isAcceptableOrUnknown(
              data['definition']!, _definitionMeta));
    } else if (isInserting) {
      context.missing(_definitionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KeyTermRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeyTermRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      term: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}term'])!,
      definition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}definition'])!,
    );
  }

  @override
  $KeyTermsTable createAlias(String alias) {
    return $KeyTermsTable(attachedDatabase, alias);
  }
}

class KeyTermRow extends DataClass implements Insertable<KeyTermRow> {
  final int id;
  final String lessonId;
  final String term;
  final String definition;
  const KeyTermRow(
      {required this.id,
      required this.lessonId,
      required this.term,
      required this.definition});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['term'] = Variable<String>(term);
    map['definition'] = Variable<String>(definition);
    return map;
  }

  KeyTermsCompanion toCompanion(bool nullToAbsent) {
    return KeyTermsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      term: Value(term),
      definition: Value(definition),
    );
  }

  factory KeyTermRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeyTermRow(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      term: serializer.fromJson<String>(json['term']),
      definition: serializer.fromJson<String>(json['definition']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'term': serializer.toJson<String>(term),
      'definition': serializer.toJson<String>(definition),
    };
  }

  KeyTermRow copyWith(
          {int? id, String? lessonId, String? term, String? definition}) =>
      KeyTermRow(
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        term: term ?? this.term,
        definition: definition ?? this.definition,
      );
  KeyTermRow copyWithCompanion(KeyTermsCompanion data) {
    return KeyTermRow(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      term: data.term.present ? data.term.value : this.term,
      definition:
          data.definition.present ? data.definition.value : this.definition,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeyTermRow(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('term: $term, ')
          ..write('definition: $definition')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lessonId, term, definition);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeyTermRow &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.term == this.term &&
          other.definition == this.definition);
}

class KeyTermsCompanion extends UpdateCompanion<KeyTermRow> {
  final Value<int> id;
  final Value<String> lessonId;
  final Value<String> term;
  final Value<String> definition;
  const KeyTermsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.term = const Value.absent(),
    this.definition = const Value.absent(),
  });
  KeyTermsCompanion.insert({
    this.id = const Value.absent(),
    required String lessonId,
    required String term,
    required String definition,
  })  : lessonId = Value(lessonId),
        term = Value(term),
        definition = Value(definition);
  static Insertable<KeyTermRow> custom({
    Expression<int>? id,
    Expression<String>? lessonId,
    Expression<String>? term,
    Expression<String>? definition,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (term != null) 'term': term,
      if (definition != null) 'definition': definition,
    });
  }

  KeyTermsCompanion copyWith(
      {Value<int>? id,
      Value<String>? lessonId,
      Value<String>? term,
      Value<String>? definition}) {
    return KeyTermsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      term: term ?? this.term,
      definition: definition ?? this.definition,
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
    if (term.present) {
      map['term'] = Variable<String>(term.value);
    }
    if (definition.present) {
      map['definition'] = Variable<String>(definition.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeyTermsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('term: $term, ')
          ..write('definition: $definition')
          ..write(')'))
        .toString();
  }
}

class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, QuestionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
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
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _choicesJsonMeta =
      const VerificationMeta('choicesJson');
  @override
  late final GeneratedColumn<String> choicesJson = GeneratedColumn<String>(
      'choices_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, lessonId, type, question, choicesJson, answer];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(Insertable<QuestionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('choices_json')) {
      context.handle(
          _choicesJsonMeta,
          choicesJson.isAcceptableOrUnknown(
              data['choices_json']!, _choicesJsonMeta));
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      choicesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}choices_json']),
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer'])!,
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class QuestionRow extends DataClass implements Insertable<QuestionRow> {
  final int id;
  final String lessonId;
  final String type;
  final String question;
  final String? choicesJson;
  final String answer;
  const QuestionRow(
      {required this.id,
      required this.lessonId,
      required this.type,
      required this.question,
      this.choicesJson,
      required this.answer});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['type'] = Variable<String>(type);
    map['question'] = Variable<String>(question);
    if (!nullToAbsent || choicesJson != null) {
      map['choices_json'] = Variable<String>(choicesJson);
    }
    map['answer'] = Variable<String>(answer);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      type: Value(type),
      question: Value(question),
      choicesJson: choicesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(choicesJson),
      answer: Value(answer),
    );
  }

  factory QuestionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionRow(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      type: serializer.fromJson<String>(json['type']),
      question: serializer.fromJson<String>(json['question']),
      choicesJson: serializer.fromJson<String?>(json['choicesJson']),
      answer: serializer.fromJson<String>(json['answer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'type': serializer.toJson<String>(type),
      'question': serializer.toJson<String>(question),
      'choicesJson': serializer.toJson<String?>(choicesJson),
      'answer': serializer.toJson<String>(answer),
    };
  }

  QuestionRow copyWith(
          {int? id,
          String? lessonId,
          String? type,
          String? question,
          Value<String?> choicesJson = const Value.absent(),
          String? answer}) =>
      QuestionRow(
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        type: type ?? this.type,
        question: question ?? this.question,
        choicesJson: choicesJson.present ? choicesJson.value : this.choicesJson,
        answer: answer ?? this.answer,
      );
  QuestionRow copyWithCompanion(QuestionsCompanion data) {
    return QuestionRow(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      type: data.type.present ? data.type.value : this.type,
      question: data.question.present ? data.question.value : this.question,
      choicesJson:
          data.choicesJson.present ? data.choicesJson.value : this.choicesJson,
      answer: data.answer.present ? data.answer.value : this.answer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionRow(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('type: $type, ')
          ..write('question: $question, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('answer: $answer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lessonId, type, question, choicesJson, answer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionRow &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.type == this.type &&
          other.question == this.question &&
          other.choicesJson == this.choicesJson &&
          other.answer == this.answer);
}

class QuestionsCompanion extends UpdateCompanion<QuestionRow> {
  final Value<int> id;
  final Value<String> lessonId;
  final Value<String> type;
  final Value<String> question;
  final Value<String?> choicesJson;
  final Value<String> answer;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.type = const Value.absent(),
    this.question = const Value.absent(),
    this.choicesJson = const Value.absent(),
    this.answer = const Value.absent(),
  });
  QuestionsCompanion.insert({
    this.id = const Value.absent(),
    required String lessonId,
    required String type,
    required String question,
    this.choicesJson = const Value.absent(),
    required String answer,
  })  : lessonId = Value(lessonId),
        type = Value(type),
        question = Value(question),
        answer = Value(answer);
  static Insertable<QuestionRow> custom({
    Expression<int>? id,
    Expression<String>? lessonId,
    Expression<String>? type,
    Expression<String>? question,
    Expression<String>? choicesJson,
    Expression<String>? answer,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (type != null) 'type': type,
      if (question != null) 'question': question,
      if (choicesJson != null) 'choices_json': choicesJson,
      if (answer != null) 'answer': answer,
    });
  }

  QuestionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? lessonId,
      Value<String>? type,
      Value<String>? question,
      Value<String?>? choicesJson,
      Value<String>? answer}) {
    return QuestionsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      type: type ?? this.type,
      question: question ?? this.question,
      choicesJson: choicesJson ?? this.choicesJson,
      answer: answer ?? this.answer,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (choicesJson.present) {
      map['choices_json'] = Variable<String>(choicesJson.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('type: $type, ')
          ..write('question: $question, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('answer: $answer')
          ..write(')'))
        .toString();
  }
}

class $BookSolutionsTable extends BookSolutions
    with TableInfo<$BookSolutionsTable, BookSolutionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookSolutionsTable(this.attachedDatabase, [this._alias]);
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
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
      'number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
      'page', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _solutionMeta =
      const VerificationMeta('solution');
  @override
  late final GeneratedColumn<String> solution = GeneratedColumn<String>(
      'solution', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, lessonId, number, page, solution];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_solutions';
  @override
  VerificationContext validateIntegrity(Insertable<BookSolutionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
          _pageMeta, page.isAcceptableOrUnknown(data['page']!, _pageMeta));
    } else if (isInserting) {
      context.missing(_pageMeta);
    }
    if (data.containsKey('solution')) {
      context.handle(_solutionMeta,
          solution.isAcceptableOrUnknown(data['solution']!, _solutionMeta));
    } else if (isInserting) {
      context.missing(_solutionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookSolutionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookSolutionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number'])!,
      page: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page'])!,
      solution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}solution'])!,
    );
  }

  @override
  $BookSolutionsTable createAlias(String alias) {
    return $BookSolutionsTable(attachedDatabase, alias);
  }
}

class BookSolutionRow extends DataClass implements Insertable<BookSolutionRow> {
  final int id;
  final String lessonId;
  final int number;
  final int page;
  final String solution;
  const BookSolutionRow(
      {required this.id,
      required this.lessonId,
      required this.number,
      required this.page,
      required this.solution});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['number'] = Variable<int>(number);
    map['page'] = Variable<int>(page);
    map['solution'] = Variable<String>(solution);
    return map;
  }

  BookSolutionsCompanion toCompanion(bool nullToAbsent) {
    return BookSolutionsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      number: Value(number),
      page: Value(page),
      solution: Value(solution),
    );
  }

  factory BookSolutionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookSolutionRow(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      number: serializer.fromJson<int>(json['number']),
      page: serializer.fromJson<int>(json['page']),
      solution: serializer.fromJson<String>(json['solution']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'number': serializer.toJson<int>(number),
      'page': serializer.toJson<int>(page),
      'solution': serializer.toJson<String>(solution),
    };
  }

  BookSolutionRow copyWith(
          {int? id,
          String? lessonId,
          int? number,
          int? page,
          String? solution}) =>
      BookSolutionRow(
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        number: number ?? this.number,
        page: page ?? this.page,
        solution: solution ?? this.solution,
      );
  BookSolutionRow copyWithCompanion(BookSolutionsCompanion data) {
    return BookSolutionRow(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      number: data.number.present ? data.number.value : this.number,
      page: data.page.present ? data.page.value : this.page,
      solution: data.solution.present ? data.solution.value : this.solution,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookSolutionRow(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('number: $number, ')
          ..write('page: $page, ')
          ..write('solution: $solution')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lessonId, number, page, solution);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookSolutionRow &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.number == this.number &&
          other.page == this.page &&
          other.solution == this.solution);
}

class BookSolutionsCompanion extends UpdateCompanion<BookSolutionRow> {
  final Value<int> id;
  final Value<String> lessonId;
  final Value<int> number;
  final Value<int> page;
  final Value<String> solution;
  const BookSolutionsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.number = const Value.absent(),
    this.page = const Value.absent(),
    this.solution = const Value.absent(),
  });
  BookSolutionsCompanion.insert({
    this.id = const Value.absent(),
    required String lessonId,
    required int number,
    required int page,
    required String solution,
  })  : lessonId = Value(lessonId),
        number = Value(number),
        page = Value(page),
        solution = Value(solution);
  static Insertable<BookSolutionRow> custom({
    Expression<int>? id,
    Expression<String>? lessonId,
    Expression<int>? number,
    Expression<int>? page,
    Expression<String>? solution,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (number != null) 'number': number,
      if (page != null) 'page': page,
      if (solution != null) 'solution': solution,
    });
  }

  BookSolutionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? lessonId,
      Value<int>? number,
      Value<int>? page,
      Value<String>? solution}) {
    return BookSolutionsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      number: number ?? this.number,
      page: page ?? this.page,
      solution: solution ?? this.solution,
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
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (solution.present) {
      map['solution'] = Variable<String>(solution.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookSolutionsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('number: $number, ')
          ..write('page: $page, ')
          ..write('solution: $solution')
          ..write(')'))
        .toString();
  }
}

class $ChunksTable extends Chunks with TableInfo<$ChunksTable, ChunkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChunksTable(this.attachedDatabase, [this._alias]);
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
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
      'page', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _textNormalizedMeta =
      const VerificationMeta('textNormalized');
  @override
  late final GeneratedColumn<String> textNormalized = GeneratedColumn<String>(
      'text_normalized', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, lessonId, page, content, textNormalized];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chunks';
  @override
  VerificationContext validateIntegrity(Insertable<ChunkRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
          _pageMeta, page.isAcceptableOrUnknown(data['page']!, _pageMeta));
    } else if (isInserting) {
      context.missing(_pageMeta);
    }
    if (data.containsKey('text')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['text']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('text_normalized')) {
      context.handle(
          _textNormalizedMeta,
          textNormalized.isAcceptableOrUnknown(
              data['text_normalized']!, _textNormalizedMeta));
    } else if (isInserting) {
      context.missing(_textNormalizedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChunkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChunkRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      page: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text'])!,
      textNormalized: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}text_normalized'])!,
    );
  }

  @override
  $ChunksTable createAlias(String alias) {
    return $ChunksTable(attachedDatabase, alias);
  }
}

class ChunkRow extends DataClass implements Insertable<ChunkRow> {
  final int id;
  final String lessonId;
  final int page;
  final String content;
  final String textNormalized;
  const ChunkRow(
      {required this.id,
      required this.lessonId,
      required this.page,
      required this.content,
      required this.textNormalized});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['page'] = Variable<int>(page);
    map['text'] = Variable<String>(content);
    map['text_normalized'] = Variable<String>(textNormalized);
    return map;
  }

  ChunksCompanion toCompanion(bool nullToAbsent) {
    return ChunksCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      page: Value(page),
      content: Value(content),
      textNormalized: Value(textNormalized),
    );
  }

  factory ChunkRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChunkRow(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      page: serializer.fromJson<int>(json['page']),
      content: serializer.fromJson<String>(json['content']),
      textNormalized: serializer.fromJson<String>(json['textNormalized']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'page': serializer.toJson<int>(page),
      'content': serializer.toJson<String>(content),
      'textNormalized': serializer.toJson<String>(textNormalized),
    };
  }

  ChunkRow copyWith(
          {int? id,
          String? lessonId,
          int? page,
          String? content,
          String? textNormalized}) =>
      ChunkRow(
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        page: page ?? this.page,
        content: content ?? this.content,
        textNormalized: textNormalized ?? this.textNormalized,
      );
  ChunkRow copyWithCompanion(ChunksCompanion data) {
    return ChunkRow(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      page: data.page.present ? data.page.value : this.page,
      content: data.content.present ? data.content.value : this.content,
      textNormalized: data.textNormalized.present
          ? data.textNormalized.value
          : this.textNormalized,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChunkRow(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('page: $page, ')
          ..write('content: $content, ')
          ..write('textNormalized: $textNormalized')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lessonId, page, content, textNormalized);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChunkRow &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.page == this.page &&
          other.content == this.content &&
          other.textNormalized == this.textNormalized);
}

class ChunksCompanion extends UpdateCompanion<ChunkRow> {
  final Value<int> id;
  final Value<String> lessonId;
  final Value<int> page;
  final Value<String> content;
  final Value<String> textNormalized;
  const ChunksCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.page = const Value.absent(),
    this.content = const Value.absent(),
    this.textNormalized = const Value.absent(),
  });
  ChunksCompanion.insert({
    this.id = const Value.absent(),
    required String lessonId,
    required int page,
    required String content,
    required String textNormalized,
  })  : lessonId = Value(lessonId),
        page = Value(page),
        content = Value(content),
        textNormalized = Value(textNormalized);
  static Insertable<ChunkRow> custom({
    Expression<int>? id,
    Expression<String>? lessonId,
    Expression<int>? page,
    Expression<String>? content,
    Expression<String>? textNormalized,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (page != null) 'page': page,
      if (content != null) 'text': content,
      if (textNormalized != null) 'text_normalized': textNormalized,
    });
  }

  ChunksCompanion copyWith(
      {Value<int>? id,
      Value<String>? lessonId,
      Value<int>? page,
      Value<String>? content,
      Value<String>? textNormalized}) {
    return ChunksCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      page: page ?? this.page,
      content: content ?? this.content,
      textNormalized: textNormalized ?? this.textNormalized,
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
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (content.present) {
      map['text'] = Variable<String>(content.value);
    }
    if (textNormalized.present) {
      map['text_normalized'] = Variable<String>(textNormalized.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChunksCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('page: $page, ')
          ..write('content: $content, ')
          ..write('textNormalized: $textNormalized')
          ..write(')'))
        .toString();
  }
}

class $ChunkVectorsTable extends ChunkVectors
    with TableInfo<$ChunkVectorsTable, ChunkVectorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChunkVectorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chunkIdMeta =
      const VerificationMeta('chunkId');
  @override
  late final GeneratedColumn<int> chunkId = GeneratedColumn<int>(
      'chunk_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _vectorMeta = const VerificationMeta('vector');
  @override
  late final GeneratedColumn<Uint8List> vector = GeneratedColumn<Uint8List>(
      'vector', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [chunkId, vector];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chunk_vectors';
  @override
  VerificationContext validateIntegrity(Insertable<ChunkVectorRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('chunk_id')) {
      context.handle(_chunkIdMeta,
          chunkId.isAcceptableOrUnknown(data['chunk_id']!, _chunkIdMeta));
    }
    if (data.containsKey('vector')) {
      context.handle(_vectorMeta,
          vector.isAcceptableOrUnknown(data['vector']!, _vectorMeta));
    } else if (isInserting) {
      context.missing(_vectorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {chunkId};
  @override
  ChunkVectorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChunkVectorRow(
      chunkId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chunk_id'])!,
      vector: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}vector'])!,
    );
  }

  @override
  $ChunkVectorsTable createAlias(String alias) {
    return $ChunkVectorsTable(attachedDatabase, alias);
  }
}

class ChunkVectorRow extends DataClass implements Insertable<ChunkVectorRow> {
  final int chunkId;
  final Uint8List vector;
  const ChunkVectorRow({required this.chunkId, required this.vector});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chunk_id'] = Variable<int>(chunkId);
    map['vector'] = Variable<Uint8List>(vector);
    return map;
  }

  ChunkVectorsCompanion toCompanion(bool nullToAbsent) {
    return ChunkVectorsCompanion(
      chunkId: Value(chunkId),
      vector: Value(vector),
    );
  }

  factory ChunkVectorRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChunkVectorRow(
      chunkId: serializer.fromJson<int>(json['chunkId']),
      vector: serializer.fromJson<Uint8List>(json['vector']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chunkId': serializer.toJson<int>(chunkId),
      'vector': serializer.toJson<Uint8List>(vector),
    };
  }

  ChunkVectorRow copyWith({int? chunkId, Uint8List? vector}) => ChunkVectorRow(
        chunkId: chunkId ?? this.chunkId,
        vector: vector ?? this.vector,
      );
  ChunkVectorRow copyWithCompanion(ChunkVectorsCompanion data) {
    return ChunkVectorRow(
      chunkId: data.chunkId.present ? data.chunkId.value : this.chunkId,
      vector: data.vector.present ? data.vector.value : this.vector,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChunkVectorRow(')
          ..write('chunkId: $chunkId, ')
          ..write('vector: $vector')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(chunkId, $driftBlobEquality.hash(vector));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChunkVectorRow &&
          other.chunkId == this.chunkId &&
          $driftBlobEquality.equals(other.vector, this.vector));
}

class ChunkVectorsCompanion extends UpdateCompanion<ChunkVectorRow> {
  final Value<int> chunkId;
  final Value<Uint8List> vector;
  const ChunkVectorsCompanion({
    this.chunkId = const Value.absent(),
    this.vector = const Value.absent(),
  });
  ChunkVectorsCompanion.insert({
    this.chunkId = const Value.absent(),
    required Uint8List vector,
  }) : vector = Value(vector);
  static Insertable<ChunkVectorRow> custom({
    Expression<int>? chunkId,
    Expression<Uint8List>? vector,
  }) {
    return RawValuesInsertable({
      if (chunkId != null) 'chunk_id': chunkId,
      if (vector != null) 'vector': vector,
    });
  }

  ChunkVectorsCompanion copyWith(
      {Value<int>? chunkId, Value<Uint8List>? vector}) {
    return ChunkVectorsCompanion(
      chunkId: chunkId ?? this.chunkId,
      vector: vector ?? this.vector,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chunkId.present) {
      map['chunk_id'] = Variable<int>(chunkId.value);
    }
    if (vector.present) {
      map['vector'] = Variable<Uint8List>(vector.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChunkVectorsCompanion(')
          ..write('chunkId: $chunkId, ')
          ..write('vector: $vector')
          ..write(')'))
        .toString();
  }
}

class $PrebuiltAnswersTable extends PrebuiltAnswers
    with TableInfo<$PrebuiltAnswersTable, PrebuiltAnswerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrebuiltAnswersTable(this.attachedDatabase, [this._alias]);
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
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, lessonId, kind, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prebuilt_answers';
  @override
  VerificationContext validateIntegrity(Insertable<PrebuiltAnswerRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrebuiltAnswerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrebuiltAnswerRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
    );
  }

  @override
  $PrebuiltAnswersTable createAlias(String alias) {
    return $PrebuiltAnswersTable(attachedDatabase, alias);
  }
}

class PrebuiltAnswerRow extends DataClass
    implements Insertable<PrebuiltAnswerRow> {
  final int id;
  final String lessonId;
  final String kind;
  final String content;
  const PrebuiltAnswerRow(
      {required this.id,
      required this.lessonId,
      required this.kind,
      required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['kind'] = Variable<String>(kind);
    map['content'] = Variable<String>(content);
    return map;
  }

  PrebuiltAnswersCompanion toCompanion(bool nullToAbsent) {
    return PrebuiltAnswersCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      kind: Value(kind),
      content: Value(content),
    );
  }

  factory PrebuiltAnswerRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrebuiltAnswerRow(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      kind: serializer.fromJson<String>(json['kind']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'kind': serializer.toJson<String>(kind),
      'content': serializer.toJson<String>(content),
    };
  }

  PrebuiltAnswerRow copyWith(
          {int? id, String? lessonId, String? kind, String? content}) =>
      PrebuiltAnswerRow(
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        kind: kind ?? this.kind,
        content: content ?? this.content,
      );
  PrebuiltAnswerRow copyWithCompanion(PrebuiltAnswersCompanion data) {
    return PrebuiltAnswerRow(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      kind: data.kind.present ? data.kind.value : this.kind,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrebuiltAnswerRow(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('kind: $kind, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lessonId, kind, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrebuiltAnswerRow &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.kind == this.kind &&
          other.content == this.content);
}

class PrebuiltAnswersCompanion extends UpdateCompanion<PrebuiltAnswerRow> {
  final Value<int> id;
  final Value<String> lessonId;
  final Value<String> kind;
  final Value<String> content;
  const PrebuiltAnswersCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.kind = const Value.absent(),
    this.content = const Value.absent(),
  });
  PrebuiltAnswersCompanion.insert({
    this.id = const Value.absent(),
    required String lessonId,
    required String kind,
    required String content,
  })  : lessonId = Value(lessonId),
        kind = Value(kind),
        content = Value(content);
  static Insertable<PrebuiltAnswerRow> custom({
    Expression<int>? id,
    Expression<String>? lessonId,
    Expression<String>? kind,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (kind != null) 'kind': kind,
      if (content != null) 'content': content,
    });
  }

  PrebuiltAnswersCompanion copyWith(
      {Value<int>? id,
      Value<String>? lessonId,
      Value<String>? kind,
      Value<String>? content}) {
    return PrebuiltAnswersCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      kind: kind ?? this.kind,
      content: content ?? this.content,
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
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrebuiltAnswersCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('kind: $kind, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

class $PackMetaTable extends PackMeta
    with TableInfo<$PackMetaTable, PackMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pack_meta';
  @override
  VerificationContext validateIntegrity(Insertable<PackMetaRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  PackMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PackMetaRow(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $PackMetaTable createAlias(String alias) {
    return $PackMetaTable(attachedDatabase, alias);
  }
}

class PackMetaRow extends DataClass implements Insertable<PackMetaRow> {
  final String key;
  final String value;
  const PackMetaRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  PackMetaCompanion toCompanion(bool nullToAbsent) {
    return PackMetaCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory PackMetaRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PackMetaRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  PackMetaRow copyWith({String? key, String? value}) => PackMetaRow(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  PackMetaRow copyWithCompanion(PackMetaCompanion data) {
    return PackMetaRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PackMetaRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PackMetaRow &&
          other.key == this.key &&
          other.value == this.value);
}

class PackMetaCompanion extends UpdateCompanion<PackMetaRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const PackMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PackMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<PackMetaRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PackMetaCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return PackMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ContentDatabase extends GeneratedDatabase {
  _$ContentDatabase(QueryExecutor e) : super(e);
  $ContentDatabaseManager get managers => $ContentDatabaseManager(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $SectionsTable sections = $SectionsTable(this);
  late final $KeyTermsTable keyTerms = $KeyTermsTable(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $BookSolutionsTable bookSolutions = $BookSolutionsTable(this);
  late final $ChunksTable chunks = $ChunksTable(this);
  late final $ChunkVectorsTable chunkVectors = $ChunkVectorsTable(this);
  late final $PrebuiltAnswersTable prebuiltAnswers =
      $PrebuiltAnswersTable(this);
  late final $PackMetaTable packMeta = $PackMetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        subjects,
        units,
        lessons,
        sections,
        keyTerms,
        questions,
        bookSolutions,
        chunks,
        chunkVectors,
        prebuiltAnswers,
        packMeta
      ];
}

typedef $$SubjectsTableCreateCompanionBuilder = SubjectsCompanion Function({
  required String id,
  required String name,
  Value<bool> tutorEnabled,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$SubjectsTableUpdateCompanionBuilder = SubjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<bool> tutorEnabled,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$SubjectsTableFilterComposer
    extends Composer<_$ContentDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get tutorEnabled => $composableBuilder(
      column: $table.tutorEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$ContentDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get tutorEnabled => $composableBuilder(
      column: $table.tutorEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get tutorEnabled => $composableBuilder(
      column: $table.tutorEnabled, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$SubjectsTableTableManager extends RootTableManager<
    _$ContentDatabase,
    $SubjectsTable,
    SubjectRow,
    $$SubjectsTableFilterComposer,
    $$SubjectsTableOrderingComposer,
    $$SubjectsTableAnnotationComposer,
    $$SubjectsTableCreateCompanionBuilder,
    $$SubjectsTableUpdateCompanionBuilder,
    (SubjectRow, BaseReferences<_$ContentDatabase, $SubjectsTable, SubjectRow>),
    SubjectRow,
    PrefetchHooks Function()> {
  $$SubjectsTableTableManager(_$ContentDatabase db, $SubjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> tutorEnabled = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubjectsCompanion(
            id: id,
            name: name,
            tutorEnabled: tutorEnabled,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<bool> tutorEnabled = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubjectsCompanion.insert(
            id: id,
            name: name,
            tutorEnabled: tutorEnabled,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SubjectsTable, SubjectRow>(table),
                    BaseReferences<_$ContentDatabase, $SubjectsTable,
                        SubjectRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubjectsTableProcessedTableManager = ProcessedTableManager<
    _$ContentDatabase,
    $SubjectsTable,
    SubjectRow,
    $$SubjectsTableFilterComposer,
    $$SubjectsTableOrderingComposer,
    $$SubjectsTableAnnotationComposer,
    $$SubjectsTableCreateCompanionBuilder,
    $$SubjectsTableUpdateCompanionBuilder,
    (SubjectRow, BaseReferences<_$ContentDatabase, $SubjectsTable, SubjectRow>),
    SubjectRow,
    PrefetchHooks Function()>;
typedef $$UnitsTableCreateCompanionBuilder = UnitsCompanion Function({
  required String id,
  required String subjectId,
  required String title,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$UnitsTableUpdateCompanionBuilder = UnitsCompanion Function({
  Value<String> id,
  Value<String> subjectId,
  Value<String> title,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$UnitsTableFilterComposer
    extends Composer<_$ContentDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$UnitsTableOrderingComposer
    extends Composer<_$ContentDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$UnitsTableTableManager extends RootTableManager<
    _$ContentDatabase,
    $UnitsTable,
    UnitRow,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (UnitRow, BaseReferences<_$ContentDatabase, $UnitsTable, UnitRow>),
    UnitRow,
    PrefetchHooks Function()> {
  $$UnitsTableTableManager(_$ContentDatabase db, $UnitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> subjectId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitsCompanion(
            id: id,
            subjectId: subjectId,
            title: title,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String subjectId,
            required String title,
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitsCompanion.insert(
            id: id,
            subjectId: subjectId,
            title: title,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$UnitsTable, UnitRow>(table),
                    BaseReferences<_$ContentDatabase, $UnitsTable, UnitRow>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UnitsTableProcessedTableManager = ProcessedTableManager<
    _$ContentDatabase,
    $UnitsTable,
    UnitRow,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (UnitRow, BaseReferences<_$ContentDatabase, $UnitsTable, UnitRow>),
    UnitRow,
    PrefetchHooks Function()>;
typedef $$LessonsTableCreateCompanionBuilder = LessonsCompanion Function({
  required String id,
  required String unitId,
  required String subjectId,
  required String title,
  Value<int> sortOrder,
  Value<String?> videoUrl,
  Value<String?> videoChaptersJson,
  Value<int?> bookPagesFrom,
  Value<int?> bookPagesTo,
  Value<String?> pdfFile,
  Value<bool> tutorEnabled,
  Value<int> rowid,
});
typedef $$LessonsTableUpdateCompanionBuilder = LessonsCompanion Function({
  Value<String> id,
  Value<String> unitId,
  Value<String> subjectId,
  Value<String> title,
  Value<int> sortOrder,
  Value<String?> videoUrl,
  Value<String?> videoChaptersJson,
  Value<int?> bookPagesFrom,
  Value<int?> bookPagesTo,
  Value<String?> pdfFile,
  Value<bool> tutorEnabled,
  Value<int> rowid,
});

class $$LessonsTableFilterComposer
    extends Composer<_$ContentDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get videoUrl => $composableBuilder(
      column: $table.videoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get videoChaptersJson => $composableBuilder(
      column: $table.videoChaptersJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookPagesFrom => $composableBuilder(
      column: $table.bookPagesFrom, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookPagesTo => $composableBuilder(
      column: $table.bookPagesTo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pdfFile => $composableBuilder(
      column: $table.pdfFile, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get tutorEnabled => $composableBuilder(
      column: $table.tutorEnabled, builder: (column) => ColumnFilters(column));
}

class $$LessonsTableOrderingComposer
    extends Composer<_$ContentDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get videoUrl => $composableBuilder(
      column: $table.videoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get videoChaptersJson => $composableBuilder(
      column: $table.videoChaptersJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookPagesFrom => $composableBuilder(
      column: $table.bookPagesFrom,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookPagesTo => $composableBuilder(
      column: $table.bookPagesTo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pdfFile => $composableBuilder(
      column: $table.pdfFile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get tutorEnabled => $composableBuilder(
      column: $table.tutorEnabled,
      builder: (column) => ColumnOrderings(column));
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => column);

  GeneratedColumn<String> get videoChaptersJson => $composableBuilder(
      column: $table.videoChaptersJson, builder: (column) => column);

  GeneratedColumn<int> get bookPagesFrom => $composableBuilder(
      column: $table.bookPagesFrom, builder: (column) => column);

  GeneratedColumn<int> get bookPagesTo => $composableBuilder(
      column: $table.bookPagesTo, builder: (column) => column);

  GeneratedColumn<String> get pdfFile =>
      $composableBuilder(column: $table.pdfFile, builder: (column) => column);

  GeneratedColumn<bool> get tutorEnabled => $composableBuilder(
      column: $table.tutorEnabled, builder: (column) => column);
}

class $$LessonsTableTableManager extends RootTableManager<
    _$ContentDatabase,
    $LessonsTable,
    LessonRow,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (LessonRow, BaseReferences<_$ContentDatabase, $LessonsTable, LessonRow>),
    LessonRow,
    PrefetchHooks Function()> {
  $$LessonsTableTableManager(_$ContentDatabase db, $LessonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> unitId = const Value.absent(),
            Value<String> subjectId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String?> videoUrl = const Value.absent(),
            Value<String?> videoChaptersJson = const Value.absent(),
            Value<int?> bookPagesFrom = const Value.absent(),
            Value<int?> bookPagesTo = const Value.absent(),
            Value<String?> pdfFile = const Value.absent(),
            Value<bool> tutorEnabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonsCompanion(
            id: id,
            unitId: unitId,
            subjectId: subjectId,
            title: title,
            sortOrder: sortOrder,
            videoUrl: videoUrl,
            videoChaptersJson: videoChaptersJson,
            bookPagesFrom: bookPagesFrom,
            bookPagesTo: bookPagesTo,
            pdfFile: pdfFile,
            tutorEnabled: tutorEnabled,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String unitId,
            required String subjectId,
            required String title,
            Value<int> sortOrder = const Value.absent(),
            Value<String?> videoUrl = const Value.absent(),
            Value<String?> videoChaptersJson = const Value.absent(),
            Value<int?> bookPagesFrom = const Value.absent(),
            Value<int?> bookPagesTo = const Value.absent(),
            Value<String?> pdfFile = const Value.absent(),
            Value<bool> tutorEnabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonsCompanion.insert(
            id: id,
            unitId: unitId,
            subjectId: subjectId,
            title: title,
            sortOrder: sortOrder,
            videoUrl: videoUrl,
            videoChaptersJson: videoChaptersJson,
            bookPagesFrom: bookPagesFrom,
            bookPagesTo: bookPagesTo,
            pdfFile: pdfFile,
            tutorEnabled: tutorEnabled,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LessonsTable, LessonRow>(table),
                    BaseReferences<_$ContentDatabase, $LessonsTable, LessonRow>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LessonsTableProcessedTableManager = ProcessedTableManager<
    _$ContentDatabase,
    $LessonsTable,
    LessonRow,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (LessonRow, BaseReferences<_$ContentDatabase, $LessonsTable, LessonRow>),
    LessonRow,
    PrefetchHooks Function()>;
typedef $$SectionsTableCreateCompanionBuilder = SectionsCompanion Function({
  Value<int> id,
  required String lessonId,
  required String title,
  required String body,
  Value<int> sortOrder,
});
typedef $$SectionsTableUpdateCompanionBuilder = SectionsCompanion Function({
  Value<int> id,
  Value<String> lessonId,
  Value<String> title,
  Value<String> body,
  Value<int> sortOrder,
});

class $$SectionsTableFilterComposer
    extends Composer<_$ContentDatabase, $SectionsTable> {
  $$SectionsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$SectionsTableOrderingComposer
    extends Composer<_$ContentDatabase, $SectionsTable> {
  $$SectionsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$SectionsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $SectionsTable> {
  $$SectionsTableAnnotationComposer({
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

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$SectionsTableTableManager extends RootTableManager<
    _$ContentDatabase,
    $SectionsTable,
    SectionRow,
    $$SectionsTableFilterComposer,
    $$SectionsTableOrderingComposer,
    $$SectionsTableAnnotationComposer,
    $$SectionsTableCreateCompanionBuilder,
    $$SectionsTableUpdateCompanionBuilder,
    (SectionRow, BaseReferences<_$ContentDatabase, $SectionsTable, SectionRow>),
    SectionRow,
    PrefetchHooks Function()> {
  $$SectionsTableTableManager(_$ContentDatabase db, $SectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              SectionsCompanion(
            id: id,
            lessonId: lessonId,
            title: title,
            body: body,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String lessonId,
            required String title,
            required String body,
            Value<int> sortOrder = const Value.absent(),
          }) =>
              SectionsCompanion.insert(
            id: id,
            lessonId: lessonId,
            title: title,
            body: body,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SectionsTable, SectionRow>(table),
                    BaseReferences<_$ContentDatabase, $SectionsTable,
                        SectionRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SectionsTableProcessedTableManager = ProcessedTableManager<
    _$ContentDatabase,
    $SectionsTable,
    SectionRow,
    $$SectionsTableFilterComposer,
    $$SectionsTableOrderingComposer,
    $$SectionsTableAnnotationComposer,
    $$SectionsTableCreateCompanionBuilder,
    $$SectionsTableUpdateCompanionBuilder,
    (SectionRow, BaseReferences<_$ContentDatabase, $SectionsTable, SectionRow>),
    SectionRow,
    PrefetchHooks Function()>;
typedef $$KeyTermsTableCreateCompanionBuilder = KeyTermsCompanion Function({
  Value<int> id,
  required String lessonId,
  required String term,
  required String definition,
});
typedef $$KeyTermsTableUpdateCompanionBuilder = KeyTermsCompanion Function({
  Value<int> id,
  Value<String> lessonId,
  Value<String> term,
  Value<String> definition,
});

class $$KeyTermsTableFilterComposer
    extends Composer<_$ContentDatabase, $KeyTermsTable> {
  $$KeyTermsTableFilterComposer({
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

  ColumnFilters<String> get term => $composableBuilder(
      column: $table.term, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definition => $composableBuilder(
      column: $table.definition, builder: (column) => ColumnFilters(column));
}

class $$KeyTermsTableOrderingComposer
    extends Composer<_$ContentDatabase, $KeyTermsTable> {
  $$KeyTermsTableOrderingComposer({
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

  ColumnOrderings<String> get term => $composableBuilder(
      column: $table.term, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definition => $composableBuilder(
      column: $table.definition, builder: (column) => ColumnOrderings(column));
}

class $$KeyTermsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $KeyTermsTable> {
  $$KeyTermsTableAnnotationComposer({
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

  GeneratedColumn<String> get term =>
      $composableBuilder(column: $table.term, builder: (column) => column);

  GeneratedColumn<String> get definition => $composableBuilder(
      column: $table.definition, builder: (column) => column);
}

class $$KeyTermsTableTableManager extends RootTableManager<
    _$ContentDatabase,
    $KeyTermsTable,
    KeyTermRow,
    $$KeyTermsTableFilterComposer,
    $$KeyTermsTableOrderingComposer,
    $$KeyTermsTableAnnotationComposer,
    $$KeyTermsTableCreateCompanionBuilder,
    $$KeyTermsTableUpdateCompanionBuilder,
    (KeyTermRow, BaseReferences<_$ContentDatabase, $KeyTermsTable, KeyTermRow>),
    KeyTermRow,
    PrefetchHooks Function()> {
  $$KeyTermsTableTableManager(_$ContentDatabase db, $KeyTermsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeyTermsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeyTermsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeyTermsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<String> term = const Value.absent(),
            Value<String> definition = const Value.absent(),
          }) =>
              KeyTermsCompanion(
            id: id,
            lessonId: lessonId,
            term: term,
            definition: definition,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String lessonId,
            required String term,
            required String definition,
          }) =>
              KeyTermsCompanion.insert(
            id: id,
            lessonId: lessonId,
            term: term,
            definition: definition,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$KeyTermsTable, KeyTermRow>(table),
                    BaseReferences<_$ContentDatabase, $KeyTermsTable,
                        KeyTermRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KeyTermsTableProcessedTableManager = ProcessedTableManager<
    _$ContentDatabase,
    $KeyTermsTable,
    KeyTermRow,
    $$KeyTermsTableFilterComposer,
    $$KeyTermsTableOrderingComposer,
    $$KeyTermsTableAnnotationComposer,
    $$KeyTermsTableCreateCompanionBuilder,
    $$KeyTermsTableUpdateCompanionBuilder,
    (KeyTermRow, BaseReferences<_$ContentDatabase, $KeyTermsTable, KeyTermRow>),
    KeyTermRow,
    PrefetchHooks Function()>;
typedef $$QuestionsTableCreateCompanionBuilder = QuestionsCompanion Function({
  Value<int> id,
  required String lessonId,
  required String type,
  required String question,
  Value<String?> choicesJson,
  required String answer,
});
typedef $$QuestionsTableUpdateCompanionBuilder = QuestionsCompanion Function({
  Value<int> id,
  Value<String> lessonId,
  Value<String> type,
  Value<String> question,
  Value<String?> choicesJson,
  Value<String> answer,
});

class $$QuestionsTableFilterComposer
    extends Composer<_$ContentDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get choicesJson => $composableBuilder(
      column: $table.choicesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnFilters(column));
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$ContentDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get choicesJson => $composableBuilder(
      column: $table.choicesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnOrderings(column));
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get choicesJson => $composableBuilder(
      column: $table.choicesJson, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);
}

class $$QuestionsTableTableManager extends RootTableManager<
    _$ContentDatabase,
    $QuestionsTable,
    QuestionRow,
    $$QuestionsTableFilterComposer,
    $$QuestionsTableOrderingComposer,
    $$QuestionsTableAnnotationComposer,
    $$QuestionsTableCreateCompanionBuilder,
    $$QuestionsTableUpdateCompanionBuilder,
    (
      QuestionRow,
      BaseReferences<_$ContentDatabase, $QuestionsTable, QuestionRow>
    ),
    QuestionRow,
    PrefetchHooks Function()> {
  $$QuestionsTableTableManager(_$ContentDatabase db, $QuestionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<String?> choicesJson = const Value.absent(),
            Value<String> answer = const Value.absent(),
          }) =>
              QuestionsCompanion(
            id: id,
            lessonId: lessonId,
            type: type,
            question: question,
            choicesJson: choicesJson,
            answer: answer,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String lessonId,
            required String type,
            required String question,
            Value<String?> choicesJson = const Value.absent(),
            required String answer,
          }) =>
              QuestionsCompanion.insert(
            id: id,
            lessonId: lessonId,
            type: type,
            question: question,
            choicesJson: choicesJson,
            answer: answer,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$QuestionsTable, QuestionRow>(table),
                    BaseReferences<_$ContentDatabase, $QuestionsTable,
                        QuestionRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuestionsTableProcessedTableManager = ProcessedTableManager<
    _$ContentDatabase,
    $QuestionsTable,
    QuestionRow,
    $$QuestionsTableFilterComposer,
    $$QuestionsTableOrderingComposer,
    $$QuestionsTableAnnotationComposer,
    $$QuestionsTableCreateCompanionBuilder,
    $$QuestionsTableUpdateCompanionBuilder,
    (
      QuestionRow,
      BaseReferences<_$ContentDatabase, $QuestionsTable, QuestionRow>
    ),
    QuestionRow,
    PrefetchHooks Function()>;
typedef $$BookSolutionsTableCreateCompanionBuilder = BookSolutionsCompanion
    Function({
  Value<int> id,
  required String lessonId,
  required int number,
  required int page,
  required String solution,
});
typedef $$BookSolutionsTableUpdateCompanionBuilder = BookSolutionsCompanion
    Function({
  Value<int> id,
  Value<String> lessonId,
  Value<int> number,
  Value<int> page,
  Value<String> solution,
});

class $$BookSolutionsTableFilterComposer
    extends Composer<_$ContentDatabase, $BookSolutionsTable> {
  $$BookSolutionsTableFilterComposer({
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

  ColumnFilters<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get solution => $composableBuilder(
      column: $table.solution, builder: (column) => ColumnFilters(column));
}

class $$BookSolutionsTableOrderingComposer
    extends Composer<_$ContentDatabase, $BookSolutionsTable> {
  $$BookSolutionsTableOrderingComposer({
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

  ColumnOrderings<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get solution => $composableBuilder(
      column: $table.solution, builder: (column) => ColumnOrderings(column));
}

class $$BookSolutionsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $BookSolutionsTable> {
  $$BookSolutionsTableAnnotationComposer({
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

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<String> get solution =>
      $composableBuilder(column: $table.solution, builder: (column) => column);
}

class $$BookSolutionsTableTableManager extends RootTableManager<
    _$ContentDatabase,
    $BookSolutionsTable,
    BookSolutionRow,
    $$BookSolutionsTableFilterComposer,
    $$BookSolutionsTableOrderingComposer,
    $$BookSolutionsTableAnnotationComposer,
    $$BookSolutionsTableCreateCompanionBuilder,
    $$BookSolutionsTableUpdateCompanionBuilder,
    (
      BookSolutionRow,
      BaseReferences<_$ContentDatabase, $BookSolutionsTable, BookSolutionRow>
    ),
    BookSolutionRow,
    PrefetchHooks Function()> {
  $$BookSolutionsTableTableManager(
      _$ContentDatabase db, $BookSolutionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookSolutionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookSolutionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookSolutionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<int> number = const Value.absent(),
            Value<int> page = const Value.absent(),
            Value<String> solution = const Value.absent(),
          }) =>
              BookSolutionsCompanion(
            id: id,
            lessonId: lessonId,
            number: number,
            page: page,
            solution: solution,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String lessonId,
            required int number,
            required int page,
            required String solution,
          }) =>
              BookSolutionsCompanion.insert(
            id: id,
            lessonId: lessonId,
            number: number,
            page: page,
            solution: solution,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$BookSolutionsTable, BookSolutionRow>(table),
                    BaseReferences<_$ContentDatabase, $BookSolutionsTable,
                        BookSolutionRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BookSolutionsTableProcessedTableManager = ProcessedTableManager<
    _$ContentDatabase,
    $BookSolutionsTable,
    BookSolutionRow,
    $$BookSolutionsTableFilterComposer,
    $$BookSolutionsTableOrderingComposer,
    $$BookSolutionsTableAnnotationComposer,
    $$BookSolutionsTableCreateCompanionBuilder,
    $$BookSolutionsTableUpdateCompanionBuilder,
    (
      BookSolutionRow,
      BaseReferences<_$ContentDatabase, $BookSolutionsTable, BookSolutionRow>
    ),
    BookSolutionRow,
    PrefetchHooks Function()>;
typedef $$ChunksTableCreateCompanionBuilder = ChunksCompanion Function({
  Value<int> id,
  required String lessonId,
  required int page,
  required String content,
  required String textNormalized,
});
typedef $$ChunksTableUpdateCompanionBuilder = ChunksCompanion Function({
  Value<int> id,
  Value<String> lessonId,
  Value<int> page,
  Value<String> content,
  Value<String> textNormalized,
});

class $$ChunksTableFilterComposer
    extends Composer<_$ContentDatabase, $ChunksTable> {
  $$ChunksTableFilterComposer({
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

  ColumnFilters<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textNormalized => $composableBuilder(
      column: $table.textNormalized,
      builder: (column) => ColumnFilters(column));
}

class $$ChunksTableOrderingComposer
    extends Composer<_$ContentDatabase, $ChunksTable> {
  $$ChunksTableOrderingComposer({
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

  ColumnOrderings<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textNormalized => $composableBuilder(
      column: $table.textNormalized,
      builder: (column) => ColumnOrderings(column));
}

class $$ChunksTableAnnotationComposer
    extends Composer<_$ContentDatabase, $ChunksTable> {
  $$ChunksTableAnnotationComposer({
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

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get textNormalized => $composableBuilder(
      column: $table.textNormalized, builder: (column) => column);
}

class $$ChunksTableTableManager extends RootTableManager<
    _$ContentDatabase,
    $ChunksTable,
    ChunkRow,
    $$ChunksTableFilterComposer,
    $$ChunksTableOrderingComposer,
    $$ChunksTableAnnotationComposer,
    $$ChunksTableCreateCompanionBuilder,
    $$ChunksTableUpdateCompanionBuilder,
    (ChunkRow, BaseReferences<_$ContentDatabase, $ChunksTable, ChunkRow>),
    ChunkRow,
    PrefetchHooks Function()> {
  $$ChunksTableTableManager(_$ContentDatabase db, $ChunksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChunksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChunksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChunksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<int> page = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> textNormalized = const Value.absent(),
          }) =>
              ChunksCompanion(
            id: id,
            lessonId: lessonId,
            page: page,
            content: content,
            textNormalized: textNormalized,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String lessonId,
            required int page,
            required String content,
            required String textNormalized,
          }) =>
              ChunksCompanion.insert(
            id: id,
            lessonId: lessonId,
            page: page,
            content: content,
            textNormalized: textNormalized,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ChunksTable, ChunkRow>(table),
                    BaseReferences<_$ContentDatabase, $ChunksTable, ChunkRow>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChunksTableProcessedTableManager = ProcessedTableManager<
    _$ContentDatabase,
    $ChunksTable,
    ChunkRow,
    $$ChunksTableFilterComposer,
    $$ChunksTableOrderingComposer,
    $$ChunksTableAnnotationComposer,
    $$ChunksTableCreateCompanionBuilder,
    $$ChunksTableUpdateCompanionBuilder,
    (ChunkRow, BaseReferences<_$ContentDatabase, $ChunksTable, ChunkRow>),
    ChunkRow,
    PrefetchHooks Function()>;
typedef $$ChunkVectorsTableCreateCompanionBuilder = ChunkVectorsCompanion
    Function({
  Value<int> chunkId,
  required Uint8List vector,
});
typedef $$ChunkVectorsTableUpdateCompanionBuilder = ChunkVectorsCompanion
    Function({
  Value<int> chunkId,
  Value<Uint8List> vector,
});

class $$ChunkVectorsTableFilterComposer
    extends Composer<_$ContentDatabase, $ChunkVectorsTable> {
  $$ChunkVectorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get chunkId => $composableBuilder(
      column: $table.chunkId, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get vector => $composableBuilder(
      column: $table.vector, builder: (column) => ColumnFilters(column));
}

class $$ChunkVectorsTableOrderingComposer
    extends Composer<_$ContentDatabase, $ChunkVectorsTable> {
  $$ChunkVectorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get chunkId => $composableBuilder(
      column: $table.chunkId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get vector => $composableBuilder(
      column: $table.vector, builder: (column) => ColumnOrderings(column));
}

class $$ChunkVectorsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $ChunkVectorsTable> {
  $$ChunkVectorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get chunkId =>
      $composableBuilder(column: $table.chunkId, builder: (column) => column);

  GeneratedColumn<Uint8List> get vector =>
      $composableBuilder(column: $table.vector, builder: (column) => column);
}

class $$ChunkVectorsTableTableManager extends RootTableManager<
    _$ContentDatabase,
    $ChunkVectorsTable,
    ChunkVectorRow,
    $$ChunkVectorsTableFilterComposer,
    $$ChunkVectorsTableOrderingComposer,
    $$ChunkVectorsTableAnnotationComposer,
    $$ChunkVectorsTableCreateCompanionBuilder,
    $$ChunkVectorsTableUpdateCompanionBuilder,
    (
      ChunkVectorRow,
      BaseReferences<_$ContentDatabase, $ChunkVectorsTable, ChunkVectorRow>
    ),
    ChunkVectorRow,
    PrefetchHooks Function()> {
  $$ChunkVectorsTableTableManager(
      _$ContentDatabase db, $ChunkVectorsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChunkVectorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChunkVectorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChunkVectorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> chunkId = const Value.absent(),
            Value<Uint8List> vector = const Value.absent(),
          }) =>
              ChunkVectorsCompanion(
            chunkId: chunkId,
            vector: vector,
          ),
          createCompanionCallback: ({
            Value<int> chunkId = const Value.absent(),
            required Uint8List vector,
          }) =>
              ChunkVectorsCompanion.insert(
            chunkId: chunkId,
            vector: vector,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ChunkVectorsTable, ChunkVectorRow>(table),
                    BaseReferences<_$ContentDatabase, $ChunkVectorsTable,
                        ChunkVectorRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChunkVectorsTableProcessedTableManager = ProcessedTableManager<
    _$ContentDatabase,
    $ChunkVectorsTable,
    ChunkVectorRow,
    $$ChunkVectorsTableFilterComposer,
    $$ChunkVectorsTableOrderingComposer,
    $$ChunkVectorsTableAnnotationComposer,
    $$ChunkVectorsTableCreateCompanionBuilder,
    $$ChunkVectorsTableUpdateCompanionBuilder,
    (
      ChunkVectorRow,
      BaseReferences<_$ContentDatabase, $ChunkVectorsTable, ChunkVectorRow>
    ),
    ChunkVectorRow,
    PrefetchHooks Function()>;
typedef $$PrebuiltAnswersTableCreateCompanionBuilder = PrebuiltAnswersCompanion
    Function({
  Value<int> id,
  required String lessonId,
  required String kind,
  required String content,
});
typedef $$PrebuiltAnswersTableUpdateCompanionBuilder = PrebuiltAnswersCompanion
    Function({
  Value<int> id,
  Value<String> lessonId,
  Value<String> kind,
  Value<String> content,
});

class $$PrebuiltAnswersTableFilterComposer
    extends Composer<_$ContentDatabase, $PrebuiltAnswersTable> {
  $$PrebuiltAnswersTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));
}

class $$PrebuiltAnswersTableOrderingComposer
    extends Composer<_$ContentDatabase, $PrebuiltAnswersTable> {
  $$PrebuiltAnswersTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));
}

class $$PrebuiltAnswersTableAnnotationComposer
    extends Composer<_$ContentDatabase, $PrebuiltAnswersTable> {
  $$PrebuiltAnswersTableAnnotationComposer({
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

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);
}

class $$PrebuiltAnswersTableTableManager extends RootTableManager<
    _$ContentDatabase,
    $PrebuiltAnswersTable,
    PrebuiltAnswerRow,
    $$PrebuiltAnswersTableFilterComposer,
    $$PrebuiltAnswersTableOrderingComposer,
    $$PrebuiltAnswersTableAnnotationComposer,
    $$PrebuiltAnswersTableCreateCompanionBuilder,
    $$PrebuiltAnswersTableUpdateCompanionBuilder,
    (
      PrebuiltAnswerRow,
      BaseReferences<_$ContentDatabase, $PrebuiltAnswersTable,
          PrebuiltAnswerRow>
    ),
    PrebuiltAnswerRow,
    PrefetchHooks Function()> {
  $$PrebuiltAnswersTableTableManager(
      _$ContentDatabase db, $PrebuiltAnswersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrebuiltAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrebuiltAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrebuiltAnswersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<String> content = const Value.absent(),
          }) =>
              PrebuiltAnswersCompanion(
            id: id,
            lessonId: lessonId,
            kind: kind,
            content: content,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String lessonId,
            required String kind,
            required String content,
          }) =>
              PrebuiltAnswersCompanion.insert(
            id: id,
            lessonId: lessonId,
            kind: kind,
            content: content,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PrebuiltAnswersTable, PrebuiltAnswerRow>(
                        table),
                    BaseReferences<_$ContentDatabase, $PrebuiltAnswersTable,
                        PrebuiltAnswerRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PrebuiltAnswersTableProcessedTableManager = ProcessedTableManager<
    _$ContentDatabase,
    $PrebuiltAnswersTable,
    PrebuiltAnswerRow,
    $$PrebuiltAnswersTableFilterComposer,
    $$PrebuiltAnswersTableOrderingComposer,
    $$PrebuiltAnswersTableAnnotationComposer,
    $$PrebuiltAnswersTableCreateCompanionBuilder,
    $$PrebuiltAnswersTableUpdateCompanionBuilder,
    (
      PrebuiltAnswerRow,
      BaseReferences<_$ContentDatabase, $PrebuiltAnswersTable,
          PrebuiltAnswerRow>
    ),
    PrebuiltAnswerRow,
    PrefetchHooks Function()>;
typedef $$PackMetaTableCreateCompanionBuilder = PackMetaCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$PackMetaTableUpdateCompanionBuilder = PackMetaCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$PackMetaTableFilterComposer
    extends Composer<_$ContentDatabase, $PackMetaTable> {
  $$PackMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$PackMetaTableOrderingComposer
    extends Composer<_$ContentDatabase, $PackMetaTable> {
  $$PackMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$PackMetaTableAnnotationComposer
    extends Composer<_$ContentDatabase, $PackMetaTable> {
  $$PackMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PackMetaTableTableManager extends RootTableManager<
    _$ContentDatabase,
    $PackMetaTable,
    PackMetaRow,
    $$PackMetaTableFilterComposer,
    $$PackMetaTableOrderingComposer,
    $$PackMetaTableAnnotationComposer,
    $$PackMetaTableCreateCompanionBuilder,
    $$PackMetaTableUpdateCompanionBuilder,
    (
      PackMetaRow,
      BaseReferences<_$ContentDatabase, $PackMetaTable, PackMetaRow>
    ),
    PackMetaRow,
    PrefetchHooks Function()> {
  $$PackMetaTableTableManager(_$ContentDatabase db, $PackMetaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PackMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PackMetaCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              PackMetaCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PackMetaTable, PackMetaRow>(table),
                    BaseReferences<_$ContentDatabase, $PackMetaTable,
                        PackMetaRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PackMetaTableProcessedTableManager = ProcessedTableManager<
    _$ContentDatabase,
    $PackMetaTable,
    PackMetaRow,
    $$PackMetaTableFilterComposer,
    $$PackMetaTableOrderingComposer,
    $$PackMetaTableAnnotationComposer,
    $$PackMetaTableCreateCompanionBuilder,
    $$PackMetaTableUpdateCompanionBuilder,
    (
      PackMetaRow,
      BaseReferences<_$ContentDatabase, $PackMetaTable, PackMetaRow>
    ),
    PackMetaRow,
    PrefetchHooks Function()>;

class $ContentDatabaseManager {
  final _$ContentDatabase _db;
  $ContentDatabaseManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$SectionsTableTableManager get sections =>
      $$SectionsTableTableManager(_db, _db.sections);
  $$KeyTermsTableTableManager get keyTerms =>
      $$KeyTermsTableTableManager(_db, _db.keyTerms);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$BookSolutionsTableTableManager get bookSolutions =>
      $$BookSolutionsTableTableManager(_db, _db.bookSolutions);
  $$ChunksTableTableManager get chunks =>
      $$ChunksTableTableManager(_db, _db.chunks);
  $$ChunkVectorsTableTableManager get chunkVectors =>
      $$ChunkVectorsTableTableManager(_db, _db.chunkVectors);
  $$PrebuiltAnswersTableTableManager get prebuiltAnswers =>
      $$PrebuiltAnswersTableTableManager(_db, _db.prebuiltAnswers);
  $$PackMetaTableTableManager get packMeta =>
      $$PackMetaTableTableManager(_db, _db.packMeta);
}
