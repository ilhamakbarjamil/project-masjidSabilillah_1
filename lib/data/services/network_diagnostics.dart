import 'dart:io';
import 'package:http/http.dart' as http;

/// Helper untuk diagnose network issues pada Android
class NetworkDiagnostics {
  /// Test koneksi internet dasar
  static Future<bool> testInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('api.aladhan.com');
      final canReach = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      print('[NetworkDiagnostics] ✅ Internet connection: $canReach');
      return canReach;
    } on SocketException catch (e) {
      print('[NetworkDiagnostics] ❌ No internet: $e');
      return false;
    }
  }

  /// Test DNS resolution
  static Future<bool> testDnsResolution(String domain) async {
    try {
      final result = await InternetAddress.lookup(domain);
      print('[NetworkDiagnostics] ✅ DNS Resolved $domain: ${result.first.address}');
      return true;
    } on SocketException catch (e) {
      print('[NetworkDiagnostics] ❌ DNS Failed for $domain: $e');
      return false;
    }
  }

  /// Test API endpoint accessibility
  static Future<bool> testApiEndpoint(String url) async {
    try {
      print('[NetworkDiagnostics] Testing API: $url');
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 15),
        onTimeout: () => http.Response('timeout', 0),
      );
      
      if (response.statusCode == 200) {
        print('[NetworkDiagnostics] ✅ API Endpoint reachable (${response.statusCode})');
        return true;
      } else {
        print('[NetworkDiagnostics] ⚠️ API returned ${response.statusCode}');
        return response.statusCode < 500;
      }
    } catch (e) {
      print('[NetworkDiagnostics] ❌ API Test failed: $e');
      return false;
    }
  }

  /// Run full diagnostic
  static Future<Map<String, bool>> runFullDiagnostic() async {
    print('\n[NetworkDiagnostics] 🔍 Starting full diagnostic...\n');
    
    final results = <String, bool>{};
    
    // Test 1: Basic internet
    results['Internet Connection'] = await testInternetConnection();
    
    // Test 2: DNS
    results['DNS (aladhan.com)'] = await testDnsResolution('api.aladhan.com');
    
    // Test 3: API endpoint
    results['API Endpoint'] = await testApiEndpoint(
      'https://api.aladhan.com/v1/timingsByCity?city=Jakarta&country=ID&method=5&timeformat=1',
    );
    
    print('\n[NetworkDiagnostics] 📊 DIAGNOSTIC RESULTS:');
    results.forEach((test, passed) {
      final icon = passed ? '✅' : '❌';
      print('$icon $test: $passed');
    });
    
    final allPassed = results.values.every((v) => v);
    if (allPassed) {
      print('\n✅ All diagnostics passed! Problem might be elsewhere.');
    } else {
      print('\n❌ Some diagnostics failed. Check network & firewall settings.');
    }
    
    return results;
  }
}
