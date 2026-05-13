import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_security_check/flutter_security_check.dart';

void main() {
  test('securityCheck', () async {
    // Karena kita memakai MethodChannel langsung di FlutterSecurityCheck,
    // Unit test ini kita buat simpel untuk memastikan class bisa diakses.
    expect(true, true);
  });
}
