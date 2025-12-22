import 'package:flutter/material.dart';
import 'package:masjid_sabilillah/core/services/network_diagnostic_service.dart';

class NetworkDiagnosticScreen extends StatefulWidget {
  const NetworkDiagnosticScreen({super.key});

  @override
  State<NetworkDiagnosticScreen> createState() => _NetworkDiagnosticScreenState();
}

class _NetworkDiagnosticScreenState extends State<NetworkDiagnosticScreen> {
  Map<String, dynamic>? _results;
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final results = await NetworkDiagnosticService.diagnoseNetwork();
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Diagnostic'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _runDiagnostics,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Run Diagnostics Again'),
                  ),
                  const SizedBox(height: 20),
                  if (_error.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Error: $_error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (_results != null) ...[
                    _buildTestResult('Connectivity Check', _results!['connectivity']),
                    _buildTestResult('DNS Resolution', _results!['dns_test']),
                    _buildTestResult('HTTPS Connection', _results!['https_test']),
                    _buildTestResult('API Endpoint', _results!['api_test']),
                    _buildTestResult('Network Interfaces', _results!['network_interface']),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildTestResult(String title, Map<String, dynamic> result) {
    final isSuccess = result['status'] == 'success';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error_circle,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildResultDetails(result),
          ),
        ],
      ),
    );
  }

  Widget _buildResultDetails(Map<String, dynamic> result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: result.entries.map((e) {
        final value = e.value;
        final displayValue = _formatValue(value);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${e.key}: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(displayValue),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatValue(dynamic value) {
    if (value is List) {
      return value.join('\n');
    } else if (value is Map) {
      return value.entries
          .map((e) => '${e.key}: ${_formatValue(e.value)}')
          .join('\n');
    }
    return value.toString();
  }
}
