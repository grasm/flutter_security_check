# flutter_security_check

A robust Flutter plugin for Android and iOS app integrity and security checks. This plugin helps protect your application from reverse engineering, debugging, and unauthorized modifications.

## Features

- **Anti-Root & Jailbreak Detection**: Detects common root binaries, management apps (Magisk, SuperSU, etc.), and iOS jailbreak environments (Cydia, Substrate).
- **Anti-Debugger (Native Level)**: Uses low-level `ptrace` and `sysctl` checks to detect attached debuggers.
- **Anti-Frida & Anti-Hooking**: Scans memory mappings and dyld images for Frida agents, gadgets, Substrate, and common hooking signatures.
- **App Integrity & Cloner Detection**: Verifies installer packages (AppStore vs AdHoc/TestFlight) and detects if the app is running in a cloned environment (Parallel Space, Dual Apps).
- **Network Security**: Detects active system proxies and VPN connections.
- **Environment & Malware Prevention**: Detects Mock Location (GPS Spoofing), running Accessibility Services (Overlay malware), and blocks Screen Capture/Recording (via `FLAG_SECURE` on Android and secure overlays on iOS).
- **Play Integrity API**: Built-in support to request a Google Play Integrity token (Android) for backend validation.
- **Security Details**: Provides a detailed dictionary of all security threats detected.

## Getting Started

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_security_check: ^0.3.3
```

## Usage

### Simple Check

```dart
bool isSecure = await FlutterSecurityCheck.isDeviceSecure;
if (!isSecure) {
  // Take action (e.g., close app)
}
```

### Detailed Security Report

```dart
Map<String, dynamic> details = await FlutterSecurityCheck.securityDetails;

print("Is Rooted: ${details['isRooted']}");
print("Is Emulator: ${details['isEmulator']}");
print("Is Debugger Attached: ${details['isDebuggerAttached']}");
print("Is Frida/Native Threat: ${details['isFridaOrNativeThreat']}");
print("Is Proxy Enabled: ${details['isProxyEnabled']}");
print("Is VPN Active: ${details['isVpnActive']}");
print("Is Xposed Detected: ${details['isXposedDetected']}");
print("Is App Cloned: ${details['isAppClone']}");
print("Is Mock Location: ${details['isMockLocation']}");
print("Is Accessibility Enabled: ${details['isAccessibilityEnabled']}");
print("App Signature Hash: ${details['appSignature']}");

// Play Integrity
String? token = await FlutterSecurityCheck.requestPlayIntegrityToken("your_nonce_here");
// Screen Capture prevention
await FlutterSecurityCheck.preventScreenCapture(true);
```

## Technical Details

The plugin uses a sophisticated multi-layered security approach:
1.  **Dart Layer**: Provides a clean asynchronous API for Flutter.
2.  **Kotlin/Swift Layer**: Manages platform-specific security checks, context-based settings analysis, package management queries, and OS-level API integrations (like Play Integrity).
3.  **C++ (Native/JNI) Layer**:
    *   Implements **Instruction Pattern Matching** to detect inline hooks at the assembly level.
    *   Handles string obfuscation to bypass basic static analysis.
    *   Directly interacts with Linux system files and network sockets for high-integrity detection.

## License

MIT License
