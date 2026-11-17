import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/features/content_manager/domain/entities/manifest.dart';
import 'package:mualimi/features/content_manager/domain/entities/pack_schema_status.dart';
import 'package:mualimi/features/content_manager/domain/repositories/installed_content_repository.dart';
import 'package:mualimi/features/content_manager/domain/repositories/manifest_repository.dart';
import 'package:mualimi/features/content_manager/domain/usecases/check_pack_update_usecase.dart';

import 'helpers/pack_download_fakes.dart';

class _OneVersionManifest implements ManifestRepository {
  @override
  Future<Either<Failure, Manifest>> getManifest() async =>
      Right(Manifest(schemaVersion: 1, packs: [pack(9, version: 3)]));
}

class _Installed implements InstalledContentRepository {
  _Installed(this.version, this.schema);

  final int? version;
  final PackSchemaStatus? schema;

  @override
  Future<int?> installedPackVersion() async => version;

  @override
  Future<bool> isPackInstalled() async => schema == PackSchemaStatus.compatible;

  @override
  Future<PackSchemaStatus?> installedSchemaStatus() async => schema;
}

void main() {
  Future<int?> offeredVersion(int? installed, PackSchemaStatus? schema) async {
    final result =
        await CheckPackUpdateUseCase(_OneVersionManifest(), _Installed(installed, schema))(9);
    return result.getOrElse(() => throw StateError('unexpected failure'))?.version;
  }

  test('compatible pack at the offered version is current', () async {
    expect(await offeredVersion(3, PackSchemaStatus.compatible), isNull);
  });

  test('compatible older pack is offered the newer version', () async {
    expect(await offeredVersion(2, PackSchemaStatus.compatible), 3);
  });

  for (final status in [
    PackSchemaStatus.outdated,
    PackSchemaStatus.newer,
    PackSchemaStatus.unreadable,
  ]) {
    test('$status schema is offered again at the same version', () async {
      expect(await offeredVersion(3, status), 3);
    });
  }

  test('nothing installed offers no update', () async {
    expect(await offeredVersion(null, null), isNull);
  });
}
