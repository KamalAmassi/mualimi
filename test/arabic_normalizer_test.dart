import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/utils/arabic_normalizer.dart';

void main() {
  String n(String s) => ArabicNormalizer.normalize(s);

  test('removes diacritics', () {
    expect(n('الكَهْرَبَاءُ'), 'الكهرباء');
    expect(n('مُحَمَّد'), 'محمد');
  });

  test('removes the dagger alef', () {
    expect(n('هٰذا'), 'هذا');
  });

  test('removes tatweel', () {
    expect(n('الشـــحن'), 'الشحن');
  });

  test('maps hamza alef forms to bare alef', () {
    expect(n('أحمد إبراهيم آمن'), 'احمد ابراهيم امن');
  });

  test('maps alef maqsura to ya', () {
    expect(n('مستشفى'), 'مستشفي');
  });

  test('maps ta marbuta to ha', () {
    expect(n('مدرسة'), 'مدرسه');
  });

  test('collapses and trims whitespace', () {
    expect(n('  مرحبا \t  بكم \n'), 'مرحبا بكم');
  });

  test('leaves Latin letters and digits alone', () {
    expect(n('pH 7 قيمة'), 'pH 7 قيمه');
  });

  test('handles empty and whitespace-only input', () {
    expect(n(''), '');
    expect(n('   '), '');
  });

  test('is idempotent', () {
    const text = 'طُرُقُ الشَّحْنِ الكَهْرَبَائِيّ';
    expect(n(n(text)), n(text));
  });

  test('query and text normalize to the same form', () {
    expect(n('الإلكترونات'), n('الالكترونات'));
  });
}
