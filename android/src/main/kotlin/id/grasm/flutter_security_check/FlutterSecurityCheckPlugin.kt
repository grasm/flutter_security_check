package id.grasm.flutter_security_check

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import androidx.annotation.Keep
import java.io.File
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import com.google.android.play.core.integrity.IntegrityManagerFactory
import com.google.android.play.core.integrity.IntegrityTokenRequest
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import android.app.Activity
import android.view.WindowManager

@Keep
class FlutterSecurityCheckPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel : MethodChannel
    private var context: android.content.Context? = null
    private var activity: Activity? = null

    companion object {
        init {
            try {
                System.loadLibrary("native_security")
            } catch (e: UnsatisfiedLinkError) {
                // Silently fail, checkNativeSecurity will return false/error handled
            }
        }
    }

    @Keep
    external fun checkNativeSecurity(): Boolean

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_security_check")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "isDeviceSecure" -> {
                val isRooted = checkRoot()
                val isDebugger = android.os.Debug.isDebuggerConnected()
                val isEmulator = checkEmulator()
                val isDevMode = checkDeveloperOptions()
                val isNativeThreat = try { checkNativeSecurity() } catch (e: UnsatisfiedLinkError) { false }
                
                result.success(!(isRooted || isDebugger || isEmulator || isNativeThreat))
            }

            "preventScreenCapture" -> {
                val prevent = call.argument<Boolean>("prevent") ?: false
                activity?.let {
                    it.runOnUiThread {
                        if (prevent) {
                            it.window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        } else {
                            it.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        }
                    }
                }
                result.success(null)
            }
            "requestPlayIntegrityToken" -> {
                val nonce = call.argument<String>("nonce")
                if (nonce == null) {
                    result.error("INVALID_ARGUMENT", "Nonce is required", null)
                    return
                }
                context?.let { ctx ->
                    try {
                        val integrityManager = IntegrityManagerFactory.create(ctx)
                        val request = IntegrityTokenRequest.builder()
                            .setNonce(nonce)
                            .build()
                        integrityManager.requestIntegrityToken(request)
                            .addOnSuccessListener { response ->
                                result.success(response.token())
                            }
                            .addOnFailureListener { e ->
                                result.error("PLAY_INTEGRITY_ERROR", e.message, null)
                            }
                    } catch (e: Exception) {
                        result.error("PLAY_INTEGRITY_EXCEPTION", e.message, null)
                    }
                } ?: result.error("NO_CONTEXT", "Application context is null", null)
            }
            "getSecurityDetails" -> {
                val isNativeThreat = try { checkNativeSecurity() } catch (e: UnsatisfiedLinkError) { false }
                result.success(mapOf(
                    "isRooted" to checkRoot(),
                    "isDebuggerAttached" to android.os.Debug.isDebuggerConnected(),
                    "isEmulator" to checkEmulator(),
                    "isDevelopmentMode" to checkDeveloperOptions(),
                    "isFridaOrNativeThreat" to isNativeThreat,
                    "appSignature" to getAppSignature(),
                    "installerPackage" to getInstallerPackageName(),
                    "isProxyEnabled" to checkProxy(),
                    "isVpnActive" to checkVPN(),
                    "isXposedDetected" to checkXposed(),
                    "isMockLocation" to checkMockLocation(),
                    "isAccessibilityEnabled" to checkAccessibilityService(),
                    "isAppClone" to checkAppClone()
                ))
            }
            else -> result.notImplemented()
        }
    }

    private fun checkRoot(): Boolean {
        // 1. Check Build Tags
        val buildTags = android.os.Build.TAGS
        if (buildTags != null && buildTags.contains("test-keys")) return true

        // 2. Check SU files
        val paths = arrayOf(
            "/system/app/Superuser.apk", "/sbin/su", "/system/bin/su",
            "/system/xbin/su", "/data/local/xbin/su", "/data/local/bin/su",
            "/system/sd/xbin/su", "/working/bin/su", "/system/bin/failsafe/su",
            "/data/local/su"
        )
        for (path in paths) {
            if (File(path).exists()) return true
        }
        
        // 3. Check for Magisk/Manager packages
        val packages = arrayOf("com.topjohnwu.magisk", "org.meowcat.magiskhide")
        context?.let { ctx ->
            for (pkg in packages) {
                try {
                    ctx.packageManager.getPackageInfo(pkg, 0)
                    return true
                } catch (e: Exception) {
                    // Not found
                }
            }
        }
        
        return false
    }

    private fun checkEmulator(): Boolean {
        // 1. Basic property checks
        val isGeneric = (android.os.Build.BRAND.startsWith("generic") && android.os.Build.DEVICE.startsWith("generic"))
                || android.os.Build.FINGERPRINT.startsWith("generic")
                || android.os.Build.FINGERPRINT.startsWith("unknown")
                || android.os.Build.HARDWARE.contains("goldfish")
                || android.os.Build.HARDWARE.contains("ranchu")
                || android.os.Build.MODEL.contains("google_sdk")
                || android.os.Build.MODEL.contains("Emulator")
                || android.os.Build.MODEL.contains("Android SDK built for x86")
                || android.os.Build.MANUFACTURER.contains("Genymotion")
                || android.os.Build.PRODUCT.contains("sdk_google")
                || android.os.Build.PRODUCT.contains("google_sdk")
                || android.os.Build.PRODUCT.contains("sdk")
                || android.os.Build.PRODUCT.contains("sdk_x86")
                || android.os.Build.PRODUCT.contains("vbox86p")
                || android.os.Build.PRODUCT.contains("emulator")
                || android.os.Build.PRODUCT.contains("simulator")
        
        if (isGeneric) return true

        // 2. Advanced File Check (Emulator Drivers)
        val emulatorFiles = arrayOf(
            "/dev/socket/qemud", "/dev/qemu_pipe", "/system/lib/libc_malloc_debug_qemu.so",
            "/sys/qemu_trace", "/system/bin/qemu-props", "/dev/socket/genyd", "/dev/socket/baseband_genyd"
        )
        for (file in emulatorFiles) {
            if (File(file).exists()) return true
        }

        return false
    }

    private fun checkDeveloperOptions(): Boolean {
        return context?.let { ctx ->
            val adb = android.provider.Settings.Global.getInt(ctx.contentResolver, android.provider.Settings.Global.ADB_ENABLED, 0) != 0
            val devOptions = android.provider.Settings.Global.getInt(ctx.contentResolver, android.provider.Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0) != 0
            adb || devOptions
        } ?: false
    }

    private fun getAppSignature(): String {
        return context?.let { ctx ->
            try {
                val packageInfo = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
                    ctx.packageManager.getPackageInfo(ctx.packageName, android.content.pm.PackageManager.GET_SIGNING_CERTIFICATES)
                } else {
                    ctx.packageManager.getPackageInfo(ctx.packageName, android.content.pm.PackageManager.GET_SIGNATURES)
                }
                
                val signatures = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
                    packageInfo.signingInfo?.apkContentsSigners
                } else {
                    @Suppress("DEPRECATION")
                    packageInfo.signatures
                }

                if (signatures == null || signatures.isEmpty()) return ""

                val md = java.security.MessageDigest.getInstance("SHA-256")
                for (signature in signatures) {
                    signature?.let {
                        md.update(it.toByteArray())
                    }
                }
                android.util.Base64.encodeToString(md.digest(), android.util.Base64.NO_WRAP)
            } catch (e: Exception) {
                ""
            }
        } ?: ""
    }

    private fun getInstallerPackageName(): String {
        return context?.let { ctx ->
            try {
                ctx.packageManager.getInstallerPackageName(ctx.packageName) ?: "unknown"
            } catch (e: Exception) {
                "unknown"
            }
        } ?: "unknown"
    }

    private fun checkProxy(): Boolean {
        val proxyHost = System.getProperty("http.proxyHost")
        val proxyPort = System.getProperty("http.proxyPort")
        return proxyHost != null || proxyPort != null
    }

    private fun checkVPN(): Boolean {
        return context?.let { ctx ->
            val connectivityManager = ctx.getSystemService(android.content.Context.CONNECTIVITY_SERVICE) as android.net.ConnectivityManager
            val networks = connectivityManager.allNetworks
            for (network in networks) {
                val caps = connectivityManager.getNetworkCapabilities(network)
                if (caps != null && caps.hasTransport(android.net.NetworkCapabilities.TRANSPORT_VPN)) {
                    return true
                }
            }
            false
        } ?: false
    }

    private fun checkXposed(): Boolean {
        // 1. Check for Xposed packages
        val xposedPackages = arrayOf("de.robv.android.xposed.installer", "org.meowcat.edxposed.manager", "org.lsposed.manager")
        context?.let { ctx ->
            for (pkg in xposedPackages) {
                try {
                    ctx.packageManager.getPackageInfo(pkg, 0)
                    return true
                } catch (e: Exception) {}
            }
        }

        // 2. Check for Xposed in StackTrace (Memory check)
        try {
            throw Exception("XposedCheck")
        } catch (e: Exception) {
            for (stackTraceElement in e.stackTrace) {
                if (stackTraceElement.className.contains("de.robv.android.xposed") || 
                    stackTraceElement.className.contains("com.saurik.substrate")) {
                    return true
                }
            }
        }
        return false
    }


    private fun checkMockLocation(): Boolean {
        return context?.let { ctx ->
            var isMock = false
            try {
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                    val appOpsManager = ctx.getSystemService(android.content.Context.APP_OPS_SERVICE) as android.app.AppOpsManager
                    isMock = (appOpsManager.checkOpNoThrow(
                        android.app.AppOpsManager.OPSTR_MOCK_LOCATION,
                        android.os.Process.myUid(),
                        ctx.packageName
                    ) == android.app.AppOpsManager.MODE_ALLOWED)
                } else {
                    @Suppress("DEPRECATION")
                    isMock = android.provider.Settings.Secure.getString(ctx.contentResolver, android.provider.Settings.Secure.ALLOW_MOCK_LOCATION) != "0"
                }
            } catch (e: Exception) {}
            isMock
        } ?: false
    }

    private fun checkAccessibilityService(): Boolean {
        return context?.let { ctx ->
            var isEnabled = false
            try {
                val am = ctx.getSystemService(android.content.Context.ACCESSIBILITY_SERVICE) as android.view.accessibility.AccessibilityManager
                isEnabled = am.isEnabled && am.getEnabledAccessibilityServiceList(android.accessibilityservice.AccessibilityServiceInfo.FEEDBACK_ALL_MASK).isNotEmpty()
            } catch (e: Exception) {}
            isEnabled
        } ?: false
    }


    private fun checkAppClone(): Boolean {
        return context?.let { ctx ->
            try {
                val dataDir = ctx.applicationInfo.dataDir
                if (dataDir.contains("/999/") || dataDir.contains("/10/") || dataDir.contains("/11/")) {
                    return true
                }
                val cloneApps = arrayOf("com.lbe.parallel", "com.excelliance.duala", "com.qihoo.magic", "com.applisto.appcloner")
                for (cloneApp in cloneApps) {
                    try {
                        ctx.packageManager.getPackageInfo(cloneApp, 0)
                        return true
                    } catch (e: Exception) {}
                }
                false
            } catch (e: Exception) {
                false
            }
        } ?: false
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
