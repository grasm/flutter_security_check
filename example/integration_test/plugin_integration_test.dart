// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing


import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_security_check/flutter_security_check.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('securityCheck test', (WidgetTester tester) async {
    // Pengecekan statis tidak butuh instance
    final bool isSecure = await FlutterSecurityCheck.isDeviceSecure;
    final Map<String, dynamic> details = await FlutterSecurityCheck.securityDetails;
    
    // Pastikan fungsi mengembalikan nilai (tidak crash)
    expect(details.containsKey('isRooted'), true);
    expect(isSecure is bool, true);
  });
}
