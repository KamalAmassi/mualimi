import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/lesson/data/datasources/subject_tutor_local_data_source.dart';
import 'package:mualimi/features/lesson/data/repositories/subject_tutor_repository_impl.dart';

class _FlagSource implements SubjectTutorLocalDataSource {
  _FlagSource(this._read);
  final Future<bool> Function() _read;

  @override
  Future<bool> isTutorEnabled(String subjectId) => _read();
}

void main() {
  test('passes the subject flag through', () async {
    expect(await SubjectTutorRepositoryImpl(_FlagSource(() async => true)).isTutorEnabled('s'),
        isTrue);
    expect(await SubjectTutorRepositoryImpl(_FlagSource(() async => false)).isTutorEnabled('s'),
        isFalse);
  });

  test('a missing pack or a database error disables the tutor', () async {
    final noPack = SubjectTutorRepositoryImpl(_FlagSource(() => throw StateError('no pack')));
    final broken = SubjectTutorRepositoryImpl(_FlagSource(() => throw Exception('io')));
    expect(await noPack.isTutorEnabled('s'), isFalse);
    expect(await broken.isTutorEnabled('s'), isFalse);
  });
}
