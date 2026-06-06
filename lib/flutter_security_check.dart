import 'dart:async';
import 'package:flutter/services.dart';

/// A comprehensive Flutter security plugin for Android.
///
/// It provides methods to detect security threats such as Root, Emulator,
/// Frida, Xposed, Proxy, VPN, and App Integrity issues.
class FlutterSecurityCheck {
  static const MethodChannel _channel = MethodChannel('flutter_security_check');

  /// Returns [true] if the device is considered secure.
  ///
  /// A device is secure if it is NOT rooted, NOT an emulator,
  /// has NO debugger attached, and NO native threats (like Frida) are detected.
  static Future<bool> get isDeviceSecure async {
    try {
      final bool isSecure = await _channel.invokeMethod('isDeviceSecure');
      return isSecure;
    } catch (e) {
      return false;
    }
  }


  /// Prevents the app from being screenshotted or screen recorded.
  /// 
  /// On Android, this sets the `FLAG_SECURE` layout parameter.
  /// On iOS, this is currently a stub as iOS does not natively support blocking screenshots 
  /// without complex workarounds (e.g., UITextField secure entry shield).
  static Future<void> preventScreenCapture(bool prevent) async {
    try {
      await _channel.invokeMethod('preventScreenCapture', {'prevent': prevent});
    } catch (e) {
      // Ignored
    }
  }

  /// Requests a Google Play Integrity token (Android only).
  /// Requires a valid Google Cloud Project and Play Console setup.
  /// Returns the token string which you should verify on your backend.
  static Future<String?> requestPlayIntegrityToken(String nonce) async {
    try {
      final String? token = await _channel.invokeMethod('requestPlayIntegrityToken', {'nonce': nonce});
      return token;
    } catch (e) {
      return null;
    }
  }

  /// Returns a detailed map of security status for various modules.
  ///
  /// The returned map contains the following keys:
  /// * [isRooted]: Whether the device is rooted.
  /// * [isDebuggerAttached]: Whether a debugger is currently attached.
  /// * [isEmulator]: Whether the app is running on an emulator.
  /// * [isDevelopmentMode]: Whether ADB or Developer Settings are enabled.
  /// * [isFridaOrNativeThreat]: Whether Frida or native inline hooks are detected.
  /// * [isProxyEnabled]: Whether a system proxy is active.
  /// * [isVpnActive]: Whether a VPN connection is active.
  /// * [isXposedDetected]: Whether Xposed framework is detected.
  /// * [isMockLocation]: Whether a mock location app/provider is active.
  /// * [isAccessibilityEnabled]: Whether an accessibility service is currently enabled (useful for detecting overlay attacks).
  /// * [isAppClone]: Whether the app is running in a cloned or dual-app environment.
  /// * [appSignature]: The SHA-256 hash of the app's signing certificate.
  /// * [installerPackage]: The package name of the app installer.
  static Future<Map<String, dynamic>> get securityDetails async {
    try {
      final Map<dynamic, dynamic> details = await _channel.invokeMethod('getSecurityDetails');
      return Map<String, dynamic>.from(details);
    } catch (e) {
      return {
        "isRooted": true,
        "isDebuggerAttached": true,
        "isEmulator": true,
        "isDevelopmentMode": true,
        "isFridaOrNativeThreat": true,
        "appSignature": "",
        "installerPackage": "unknown",
        "isProxyEnabled": false,
        "isVpnActive": false,
        "isXposedDetected": false,
        "isMockLocation": false,
        "isAccessibilityEnabled": false,
        "isAppClone": false,
        "error": e.toString(),
      };
    }
  }
}
