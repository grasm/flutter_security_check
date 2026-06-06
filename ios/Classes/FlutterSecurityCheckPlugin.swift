import Flutter
import UIKit
import Foundation
import Darwin
import MachO

public class FlutterSecurityCheckPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_security_check", binaryMessenger: registrar.messenger())
    let instance = FlutterSecurityCheckPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isDeviceSecure":
      result(isDeviceSecure())

        case "preventScreenCapture":
      if let args = call.arguments as? [String: Any], let prevent = args["prevent"] as? Bool {
          preventScreenCapture(prevent)
        private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
      result(nil)
    case "getSecurityDetails":
      result(getSecurityDetails())
    default:
      result(FlutterMethodNotImplemented)
      private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
    private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}

  private func isDeviceSecure() -> Bool {
    let details = getSecurityDetails()
    if (details["isRooted"] as? Bool == true) || 
       (details["isDebuggerAttached"] as? Bool == true) || 
       (details["isEmulator"] as? Bool == true) || 
       (details["isFridaOrNativeThreat"] as? Bool == true) {
      return false
      private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
    return true
    private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}

  private func getSecurityDetails() -> [String: Any] {
    var details: [String: Any] = [:]
    
    details["isRooted"] = isJailbroken()
    details["isDebuggerAttached"] = isDebuggerAttached()
    details["isEmulator"] = isEmulator()
    details["isDevelopmentMode"] = false // Not applicable in the same way on iOS
    details["isFridaOrNativeThreat"] = isFridaDetected()
    details["isProxyEnabled"] = isProxyEnabled()
    details["isVpnActive"] = isVpnActive()
    details["isXposedDetected"] = false // Android only
    details["isMockLocation"] = false // Android mainly
    details["isAccessibilityEnabled"] = false // Android mainly
    details["isAppClone"] = false // Android mainly
    details["appSignature"] = ""
    details["installerPackage"] = getInstallerPackage()
    
    return details
    private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}

  private func isJailbroken() -> Bool {
    #if targetEnvironment(simulator)
    return false
    #else
    let filePaths = [
      "/Applications/Cydia.app",
      "/Library/MobileSubstrate/MobileSubstrate.dylib",
      "/bin/bash",
      "/usr/sbin/sshd",
      "/etc/apt",
      "/private/var/lib/apt/"
    ]
    
    for path in filePaths {
      if FileManager.default.fileExists(atPath: path) {
        return true
        private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
      private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
    
    let testPath = "/private/jailbreak.txt"
    do {
      try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
      try FileManager.default.removeItem(atPath: testPath)
      return true
    } catch {
      // Expected exception if not jailbroken
      private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
    
    if let url = URL(string: "cydia://package/com.example.package") {
      if UIApplication.shared.canOpenURL(url) {
        return true
        private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
      private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
    
    return false
    #endif
    private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}

  private func isEmulator() -> Bool {
    #if targetEnvironment(simulator)
    return true
    #else
    return false
    #endif
    private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}

  private func isDebuggerAttached() -> Bool {
    var info = kinfo_proc()
    var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
    var size = MemoryLayout<kinfo_proc>.stride
    let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
    assert(junk == 0, "sysctl failed")
    return (info.kp_proc.p_flag & P_TRACED) != 0
    private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}

  private func isFridaDetected() -> Bool {
    let count = _dyld_image_count()
    let suspiciousLibraries = [
      "FridaGadget", "frida", "cydia", "mobilesubstrate",
      "libcycript", "sslkillswitch", "substrate"
    ]
    
    for i in 0..<count {
      if let imageName = _dyld_get_image_name(i) {
        let name = String(cString: imageName).lowercased()
        for lib in suspiciousLibraries {
          if name.contains(lib) {
            return true
            private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
          private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
        private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
      private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
    return false
    private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}

  private func getInstallerPackage() -> String {
    guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
      return "unknown"
      private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
    
    let receiptPath = appStoreReceiptURL.path
    if receiptPath.contains("sandboxReceipt") {
      return "TestFlight"
      private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
    
    if FileManager.default.fileExists(atPath: Bundle.main.bundlePath + "/embedded.mobileprovision") {
      return "AdHoc/Enterprise"
      private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
    
    return "AppStore"
    private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}

  private func isProxyEnabled() -> Bool {
    guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() as? [String: Any] else {
      return false
      private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
    if let proxyEnabled = proxySettings["HTTPEnable"] as? Int, proxyEnabled == 1 {
      return true
      private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
    return false
    private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}

  private func isVpnActive() -> Bool {
    guard let dict = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any] else {
      return false
      private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
    if let scoped = dict["__SCOPED__"] as? [String: Any] {
      for key in scoped.keys {
        if key.contains("tap") || key.contains("tun") || key.contains("ppp") || key.contains("ipsec") || key.contains("ipsec0") {
          return true
          private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
        private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
      private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
    return false
    private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
  private var secureField: UITextField?

  private func preventScreenCapture(_ prevent: Bool) {
      DispatchQueue.main.async {
          if prevent {
              if self.secureField == nil {
                  let field = UITextField()
                  field.isSecureTextEntry = true
                  field.translatesAutoresizingMaskIntoConstraints = false
                  
                  if let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow {
                      window.addSubview(field)
                      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                      window.layer.superlayer?.addSublayer(field.layer)
                      field.layer.sublayers?.first?.addSublayer(window.layer)
                  }
                  self.secureField = field
              }
          } else {
              self.secureField?.removeFromSuperview()
              self.secureField = nil
          }
      }
  }
}
