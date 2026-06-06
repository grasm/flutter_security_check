import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_security_check/flutter_security_check.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('flutter_security_check');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'isDeviceSecure':
            return true;
          case 'getSecurityDetails':
            return {
              "isRooted": false,
              "isDebuggerAttached": false,
              "isEmulator": true,
              "isDevelopmentMode": false,
              "isFridaOrNativeThreat": false,
              "appSignature": "mock_signature",
              "installerPackage": "mock_installer",
              "isProxyEnabled": false,
              "isVpnActive": false,
              "isXposedDetected": false,
              "isMockLocation": false,
              "isAccessibilityEnabled": false,
              "isAppClone": false,
            };
          case 'preventScreenCapture':
            // just return null for void
            return null;
          case 'requestPlayIntegrityToken':
            return "mock_integrity_token_${methodCall.arguments['nonce']}";
          default:
            throw MissingPluginException();
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('isDeviceSecure returns true', () async {
    final bool isSecure = await FlutterSecurityCheck.isDeviceSecure;
    expect(isSecure, isTrue);
  });

  test('securityDetails returns correct mock data', () async {
    final Map<String, dynamic> details = await FlutterSecurityCheck.securityDetails;
    expect(details['isRooted'], isFalse);
    expect(details['isEmulator'], isTrue);
    expect(details['appSignature'], "mock_signature");
    expect(details['isAppClone'], isFalse);
    expect(details['isAccessibilityEnabled'], isFalse);
  });

  test('preventScreenCapture executes without error', () async {
    // Should complete normally
    await expectLater(FlutterSecurityCheck.preventScreenCapture(true), completes);
  });

  test('requestPlayIntegrityToken returns mock token', () async {
    final String? token = await FlutterSecurityCheck.requestPlayIntegrityToken("test_nonce");
    expect(token, "mock_integrity_token_test_nonce");
  });
}
