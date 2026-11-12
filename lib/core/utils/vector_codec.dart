import 'dart:typed_data';

/// Chunk vectors are stored as little-endian float32 blobs.
abstract final class VectorCodec {
  static Uint8List encode(List<double> values) {
    final data = ByteData(values.length * 4);
    for (var i = 0; i < values.length; i++) {
      data.setFloat32(i * 4, values[i], Endian.little);
    }
    return data.buffer.asUint8List();
  }

  static List<double> decode(Uint8List bytes) {
    final data = ByteData.sublistView(bytes);
    return List.generate(bytes.length ~/ 4, (i) => data.getFloat32(i * 4, Endian.little));
  }
}
