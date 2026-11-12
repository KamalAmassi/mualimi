import 'dart:math';

abstract final class VectorMath {
  /// Cosine similarity in -1..1; 0 when either vector is empty, all-zero or
  /// the lengths differ.
  static double cosine(List<double> a, List<double> b) {
    if (a.isEmpty || a.length != b.length) return 0;
    var dot = 0.0, na = 0.0, nb = 0.0;
    for (var i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      na += a[i] * a[i];
      nb += b[i] * b[i];
    }
    if (na == 0 || nb == 0) return 0;
    return dot / (sqrt(na) * sqrt(nb));
  }
}
