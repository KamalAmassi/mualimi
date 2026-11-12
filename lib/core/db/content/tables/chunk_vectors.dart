import 'package:drift/drift.dart';

/// `vector` is little-endian float32 values (see VectorCodec).
@DataClassName('ChunkVectorRow')
class ChunkVectors extends Table {
  IntColumn get chunkId => integer()();
  BlobColumn get vector => blob()();

  @override
  Set<Column> get primaryKey => {chunkId};
}
