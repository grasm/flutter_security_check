import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_security_check/flutter_security_check.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardColor: const Color(0xFF1E293B),
        primaryColor: Colors.blueAccent,
      ),
      home: const SecurityDashboard(),
    );
  }
}

class SecurityDashboard extends StatefulWidget {
  const SecurityDashboard({super.key});

  @override
  State<SecurityDashboard> createState() => _SecurityDashboardState();
}

class _SecurityDashboardState extends State<SecurityDashboard> {
  Map<String, dynamic> _details = {};
  bool _isSecure = true;
  bool _isLoading = true;
  bool _preventScreenCapture = false;
  String _playToken = "";

  @override
  void initState() {
    super.initState();
    _scanSecurity();
  }

  Future<void> _scanSecurity() async {
    setState(() => _isLoading = true);
    
    try {
      final isSecure = await FlutterSecurityCheck.isDeviceSecure;
      final details = await FlutterSecurityCheck.securityDetails;
      
      setState(() {
        _isSecure = isSecure;
        _details = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _details = {"error": e.toString()};
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Inspector Pro'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _scanSecurity,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 24),
                  const Text(
                    "Security Modules",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.3,
                    children: [
                      _buildSecurityCard("Root Status", _details['isRooted'] ?? false, Icons.admin_panel_settings, isInverse: true),
                      _buildSecurityCard("Emulator", _details['isEmulator'] ?? false, Icons.devices, isInverse: true),
                      _buildSecurityCard("Frida/Native", _details['isFridaOrNativeThreat'] ?? false, Icons.bug_report, isInverse: true),
                      _buildSecurityCard("Debugger", _details['isDebuggerAttached'] ?? false, Icons.code, isInverse: true),
                      _buildSecurityCard("Xposed", _details['isXposedDetected'] ?? false, Icons.extension, isInverse: true),
                      _buildSecurityCard("VPN Active", _details['isVpnActive'] ?? false, Icons.vpn_lock, isInverse: true),
                      _buildSecurityCard("Proxy", _details['isProxyEnabled'] ?? false, Icons.settings_ethernet, isInverse: true),
                      _buildSecurityCard("Dev Mode", _details['isDevelopmentMode'] ?? false, Icons.developer_mode, isInverse: true),
                      _buildSecurityCard("Mock GPS", _details['isMockLocation'] ?? false, Icons.location_off, isInverse: true),
                      _buildSecurityCard("Cloned App", _details['isAppClone'] ?? false, Icons.control_point_duplicate, isInverse: true),
                      _buildSecurityCard("Overlay/A11y", _details['isAccessibilityEnabled'] ?? false, Icons.accessibility, isInverse: true),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildInfoTile("App Signature Hash", _details['appSignature']?.toString() ?? "N/A"),
                  _buildInfoTile("Installer Source", _details['installerPackage']?.toString() ?? "N/A"),
                  
                  const SizedBox(height: 24),
                  const Text("Action Controls", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  SwitchListTile(
                    title: const Text("Prevent Screen Capture"),
                    subtitle: const Text("Blocks screenshots & screen recording"),
                    value: _preventScreenCapture,
                    onChanged: (val) async {
                      await FlutterSecurityCheck.preventScreenCapture(val);
                      setState(() { _preventScreenCapture = val; });
                    },
                  ),
                  
                  ListTile(
                    title: const Text("Request Play Integrity Token"),
                    subtitle: Text(_playToken.isEmpty ? "Tap to request token from Google Play" : _playToken),
                    trailing: const Icon(Icons.security_update_good),
                    onTap: () async {
                      setState(() => _playToken = "Requesting...");
                      String? token = await FlutterSecurityCheck.requestPlayIntegrityToken("example_nonce_123");
                      setState(() => _playToken = token ?? "Failed to get token");
                    },
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanSecurity,
        label: const Text("Rescan Device"),
        icon: const Icon(Icons.security),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isSecure 
            ? [Colors.green.shade700, Colors.green.shade900]
            : [Colors.red.shade700, Colors.red.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (_isSecure ? Colors.green : Colors.red).withAlpha(76),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(
            _isSecure ? Icons.verified_user : Icons.gpp_maybe,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            _isSecure ? "DEVICE SECURE" : "THREAT DETECTED",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isSecure 
              ? "All security modules passed verification."
              : "One or more security threats were identified.",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard(String title, bool isDetected, IconData icon, {bool isInverse = false}) {
    // If isInverse is true, then 'true' means a threat (Red)
    bool isSafe = isInverse ? !isDetected : isDetected;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSafe ? Colors.green.withAlpha(76) : Colors.red.withAlpha(76),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSafe ? Colors.greenAccent : Colors.redAccent, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            isSafe ? "SAFE" : "DETECTED",
            style: TextStyle(
              color: isSafe ? Colors.greenAccent : Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 4),
          SelectableText(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
