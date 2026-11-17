import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/core/services/connectivity_service.dart';
import 'package:mualimi/core/services/network_kind.dart';
import 'package:mualimi/features/content_manager/domain/entities/pack_info.dart';
import 'package:mualimi/features/content_manager/domain/usecases/check_pack_update_usecase.dart';
import 'package:mualimi/features/profile/data/datasources/storage_usage_local_data_source.dart';
import 'package:mualimi/features/profile/data/repositories/pack_update_repository_impl.dart';
import 'package:mualimi/features/profile/domain/entities/pack_update_check.dart';
import 'package:mualimi/features/profile/domain/entities/storage_usage.dart';

class _NoConnectivity extends Fake implements Connectivity {}

class _FakeCheckPackUpdate extends Fake implements CheckPackUpdateUseCase {
  _FakeCheckPackUpdate(this.result);
  final Either<Failure, PackInfo?> result;
  int calls = 0;

  @override
  Future<Either<Failure, PackInfo?>> call(int grade) async {
    calls++;
    return result;
  }
}

const _pack = PackInfo(
  grade: 9,
  track: null,
  version: 4,
  url: 'https://example.invalid/pack.zip',
  mirrors: [],
  size: 1,
  sha256: 'x',
  subjects: [],
);

void main() {
  group('StorageUsageLocalDataSource', () {
    late Directory root;
    setUp(() async => root = await Directory.systemTemp.createTemp('profile_storage'));
    tearDown(() => root.delete(recursive: true));

    test('sums content.db and every file under the PDF folder', () async {
      File('${root.path}/content.db').writeAsBytesSync(List.filled(300, 0));
      final pdf = Directory('${root.path}/pdf/sub')..createSync(recursive: true);
      File('${root.path}/pdf/a.pdf').writeAsBytesSync(List.filled(100, 0));
      File('${pdf.path}/b.pdf').writeAsBytesSync(List.filled(50, 0));
      final usage = await StorageUsageLocalDataSource(
        contentDbPath: '${root.path}/content.db',
        pdfDirPath: '${root.path}/pdf',
      ).measure();
      expect(usage, const StorageUsage(packBytes: 300, pdfBytes: 150));
      expect(usage.totalBytes, 450);
    });

    test('missing files count as zero', () async {
      final usage = await StorageUsageLocalDataSource(
        contentDbPath: '${root.path}/none.db',
        pdfDirPath: '${root.path}/none',
      ).measure();
      expect(usage, const StorageUsage(packBytes: 0, pdfBytes: 0));
    });
  });

  group('PackUpdateRepositoryImpl', () {
    ConnectivityService connectivity(NetworkKind kind) =>
        ConnectivityService(connectivity: _NoConnectivity())..network.value = kind;

    test('offline skips the check', () async {
      final check = _FakeCheckPackUpdate(const Right(null));
      final repo = PackUpdateRepositoryImpl(connectivity(NetworkKind.offline), check);
      expect(await repo.check(9), PackUpdateCheck.unavailable);
      expect(check.calls, 0);
    });

    test('online maps the use case result', () async {
      final online = connectivity(NetworkKind.wifi);
      expect(await PackUpdateRepositoryImpl(online, _FakeCheckPackUpdate(const Right(null))).check(9),
          PackUpdateCheck.upToDate);
      expect(await PackUpdateRepositoryImpl(online, _FakeCheckPackUpdate(const Right(_pack))).check(9),
          PackUpdateCheck.updateAvailable);
      expect(
          await PackUpdateRepositoryImpl(
                  online, _FakeCheckPackUpdate(const Left(NetworkFailure('down'))))
              .check(9),
          PackUpdateCheck.unavailable);
    });
  });
}
