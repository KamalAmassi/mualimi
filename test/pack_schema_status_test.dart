import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/content_manager/domain/entities/pack_schema_status.dart';

void main() {
  test('maps found schema_version against the expected one', () {
    expect(PackSchemaStatus.of(2, 2), PackSchemaStatus.compatible);
    expect(PackSchemaStatus.of(1, 2), PackSchemaStatus.outdated);
    expect(PackSchemaStatus.of(3, 2), PackSchemaStatus.newer);
    expect(PackSchemaStatus.of(null, 2), PackSchemaStatus.unreadable);
  });
}
