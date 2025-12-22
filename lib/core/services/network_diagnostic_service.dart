import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkDiagnosticService {
  static Future<Map<String, dynamic>> diagnoseNetwork() async {
    final results = <String, dynamic>{};

    // 1. Check Internet Connectivity
    results['connectivity'] = await _checkConnectivity();

    // 2. Test DNS Resolution
    results['dns_test'] = await _testDNS();

    // 3. Test HTTPS Connection to API
    results['https_test'] = await _testHTTPSConnection();

    // 4. Test API Endpoint
    results['api_test'] = await _testAPIEndpoint();

    // 5. Check Network Interface
    results['network_interface'] = await _getNetworkInterface();

    return results;
  }

  static Future<Map<String, dynamic>> _checkConnectivity() async {
    try {
      final connectivity = Connectivity();
      final result = await connectivity.checkConnectivity();
      
      return {
        'status': 'success',
        'connectivity': result.toString(),
        'connected': result != ConnectivityResult.none,
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> _testDNS() async {
    try {
      final result = await InternetAddress.lookup('api.aladhan.com');
      
      return {
        'status': 'success',
        'domain': 'api.aladhan.com',
        'ip_addresses': result.map((e) => e.address).toList(),
        'resolved': result.isNotEmpty,
      };
    } catch (e) {
      return {
        'status': 'error',
        'domain': 'api.aladhan.com',
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> _testHTTPSConnection() async {
    try {
      final socket = await Socket.connect(
        'api.aladhan.com',
        443,
        timeout: Duration(seconds: 10),
      );
      
      socket.destroy();
      
      return {
        'status': 'success',
        'host': 'api.aladhan.com',
        'port': 443,
        'connected': true,
      };
    } catch (e) {
      return {
        'status': 'error',
        'host': 'api.aladhan.com',
        'port': 443,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> _testAPIEndpoint() async {
    try {
      final http = HttpClient();
      http.connectionTimeout = Duration(seconds: 30);
      
      final request = await http.getUrl(
        Uri.parse('https://api.aladhan.com/v1/timingsByCity?city=Surabaya&country=ID&method=5'),
      );
      
      final response = await request.close();
      final statusCode = response.statusCode;
      final contentLength = response.contentLength;
      
      return {
        'status': 'success',
        'status_code': statusCode,
        'content_length': contentLength,
        'headers': {
          'content-type': response.headers.value('content-type'),
          'content-length': response.headers.value('content-length'),
        },
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> _getNetworkInterface() async {
    try {
      final interfaces = await NetworkInterface.list();
      
      return {
        'status': 'success',
        'interfaces': interfaces.map((i) {
          return {
            'name': i.name,
            'addresses': i.addresses.map((a) => {
              'address': a.address,
              'type': a.type.toString(),
            }).toList(),
          };
        }).toList(),
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }
}
