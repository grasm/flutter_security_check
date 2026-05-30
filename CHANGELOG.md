## 0.2.1
* **Swift Package Manager (SPM) Support**: Added `Package.swift` to support modern iOS/macOS integration.

## 0.2.0
* **iOS Platform Support**: Added native implementation for iOS security checks.
    * Jailbreak Detection (Cydia path checks, filesystem access, URL Schemes)
    * Simulator/Emulator Detection
    * Debugger Detection (sysctl)
    * Native Threat/Frida Detection (dyld image scan)
    * Proxy and VPN Connection Detection

## 0.1.0
* **Advanced Emulator Detection**: Added hardware property checks and specific driver/file detection (QEMU, Genymotion).
* **Enhanced Root Detection**: Added Build Tags (test-keys) check and Magisk/MagiskHide package detection.
* **Developer Options Detection**: Detects if ADB or Development Settings are enabled.
* **Proxy & VPN Detection**: Added detection for active system proxies and VPN connections.
* **Xposed/LSPosed Detection**: Added package-level and runtime stacktrace-level detection for Xposed framework.
* **Advanced Frida Detection (Native)**:
    * Added string obfuscation (XOR).
    * Added Port Scanning (27042).
    * Added Thread Name monitoring.
    * Added **Native Inline Hook Detection** for critical libc functions (ARM64/ARM/x86).
* **App Integrity**: Added SHA-256 Signature Hash retrieval and Installer Package detection.

## 0.0.1

* Initial release of `flutter_security_check`.
* Implementation of Anti-Root detection for Android.
* Implementation of Native Anti-Debugger (ptrace) check.
* Implementation of Anti-Frida memory scan detection.
* Added `isDeviceSecure` and `securityDetails` API.
