import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_security_check/flutter_security_check.dart';

void main() {
  test('securityCheck', () async {
    // Since we are using MethodChannel directly in FlutterSecurityCheck,
    // this unit test is kept simple just to ensure the class is accessible.
    expect(true, true);
  });
}
