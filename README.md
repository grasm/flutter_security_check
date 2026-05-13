# flutter_security_check

A robust Flutter plugin for Android app integrity and security checks. This plugin helps protect your application from reverse engineering, debugging, and unauthorized modifications.

## Features

- **Anti-Root Detection**: Detects common root binaries and management apps (Magisk, SuperSU, etc.).
- **Anti-Debugger (Native Level)**: Uses low-level `ptrace` checks and system status monitoring to detect attached debuggers.
- **Anti-Frida Detection**: Scans memory mappings for the presence of Frida agents, gadgets, and common hooking signatures.
- **Security Details**: Provides detailed information about which security threat was detected.

## Getting Started

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_security_check:
    path: ./plugins/flutter_security_check
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
print("App Signature Hash: ${details['appSignature']}");
```

## Technical Details

The plugin uses a sophisticated multi-layered security approach:
1.  **Dart Layer**: Provides a clean asynchronous API for Flutter.
2.  **Kotlin Layer**: Manages Android-specific security checks, context-based settings analysis, and package management queries.
3.  **C++ (Native/JNI) Layer**:
    *   Implements **Instruction Pattern Matching** to detect inline hooks at the assembly level.
    *   Handles string obfuscation to bypass basic static analysis.
    *   Directly interacts with Linux system files and network sockets for high-integrity detection.

## License

MIT License
