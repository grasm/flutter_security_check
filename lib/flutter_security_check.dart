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
        "error": e.toString(),
      };
    }
  }
}
