import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/location_controller.dart';
import '../controllers/experiment_controller.dart';
import '../services/location_service.dart';
import '../widgets/location_map.dart';

class StaticExperimentView extends StatefulWidget {
  const StaticExperimentView({super.key});

  @override
  State<StaticExperimentView> createState() => _StaticExperimentViewState();
}

class _StaticExperimentViewState extends State<StaticExperimentView> {
  final LocationController locationController = Get.find<LocationController>();
  final ExperimentController experimentController = Get.find<ExperimentController>();
  
  bool _isFetchingNetwork = false;
  bool _isFetchingGps = false;
  
  // Variabel untuk timer
  int _secondsElapsed = 0;
  Timer? _timer;

  void _startTimer() {
    _secondsElapsed = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eksperimen Indoor/Outdoor'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Obx(() => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250, 
              child: LocationMap(
                currentLocation: locationController.currentLocation.value,
                locationHistory: [
                  ...experimentController.networkData,
                  ...experimentController.gpsData,
                ],
                showPath: false,
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInstructionCard(),
                  const SizedBox(height: 16),
                  
                  // Indikator Waktu
                  if (_isFetchingNetwork || _isFetchingGps)
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.yellow[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                          const SizedBox(width: 10),
                          Text(
                            "Mencari Sinyal... ${_secondsElapsed}s",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isFetchingNetwork || _isFetchingGps ? null : _handleNetworkRecord,
                          icon: const Icon(Icons.wifi),
                          label: const Text('Get Network'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isFetchingNetwork || _isFetchingGps ? null : _handleGpsRecord,
                          icon: const Icon(Icons.satellite_alt),
                          label: const Text('Get GPS'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Error Message
                  if (locationController.errorMessage.value.isNotEmpty)
                    Text(
                      locationController.errorMessage.value,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Menampilkan Data Lengkap
                  _buildDataSection('Data Network', experimentController.networkData, Colors.orange, Icons.wifi),
                  const SizedBox(height: 12),
                  _buildDataSection('Data GPS', experimentController.gpsData, Colors.green, Icons.satellite_alt),
                  
                  const SizedBox(height: 16),
                  
                  if (experimentController.networkData.isNotEmpty || experimentController.gpsData.isNotEmpty)
                    _buildComparisonSection(experimentController),
                    
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      experimentController.clearData();
                      locationController.clearHistory();
                      setState(() => _secondsElapsed = 0);
                    },
                    child: const Text('Reset Data'),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> _handleNetworkRecord() async {
    setState(() => _isFetchingNetwork = true);
    locationController.errorMessage.value = '';
    _startTimer();
    
    final location = await locationController.getSingleLocation(LocationProvider.network);
    
    _stopTimer();
    if (mounted) setState(() => _isFetchingNetwork = false);

    if (location != null) {
      experimentController.recordNetworkLocation(location);
    }
  }

  Future<void> _handleGpsRecord() async {
    setState(() => _isFetchingGps = true);
    locationController.errorMessage.value = '';
    _startTimer();

    final location = await locationController.getSingleLocation(LocationProvider.gps);

    _stopTimer();
    if (mounted) setState(() => _isFetchingGps = false);

    if (location != null) {
      experimentController.recordGpsLocation(location);
    } else {
       Get.snackbar('Gagal Lock GPS', 'Waktu habis (${_secondsElapsed}s). Sinyal satelit tidak tembus atap.', 
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red[100], duration: const Duration(seconds: 4));
    }
  }

  Widget _buildInstructionCard() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'Catatan: "Get GPS" akan memaksa HP mencari satelit murni. Di dalam ruangan, ini akan memakan waktu lama dan hasilnya mungkin tidak akurat. Network menggunakan WiFi/Seluler.',
          style: TextStyle(fontSize: 13, color: Colors.blue[900]),
        ),
      ),
    );
  }

  // === BAGIAN YANG DIPERBARUI ===
  Widget _buildDataSection(String title, List data, Color color, IconData icon) {
    if (data.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
            ],
          ),
          const Divider(),
          // Loop data yang ada
          ...data.map((loc) => Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("Latitude", loc.latitude.toStringAsFixed(7)),
                _buildInfoRow("Longitude", loc.longitude.toStringAsFixed(7)),
                _buildInfoRow("Accuracy", "${loc.accuracy?.toStringAsFixed(2) ?? '-'} meter"),
                _buildInfoRow("Timestamp", DateFormat('HH:mm:ss').format(loc.timestamp)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // Helper untuk membuat baris teks yang rapi
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Icon(Icons.circle, size: 6, color: Colors.grey),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80, 
            child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ),
          const Text(": ", style: TextStyle(fontSize: 13, color: Colors.black54)),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonSection(ExperimentController controller) {
    final net = controller.networkData;
    final gps = controller.gpsData;
    
    if (net.isEmpty || gps.isEmpty) return const SizedBox.shrink();

    final netAcc = net.last.accuracy ?? 0;
    final gpsAcc = gps.last.accuracy ?? 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo.withOpacity(0.3))
      ),
      child: Column(
        children: [
          const Text("Perbandingan Akurasi (Makin Kecil Makin Baik)", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [
                const Text("Network", style: TextStyle(color: Colors.orange)), 
                Text("${netAcc.toStringAsFixed(1)} m", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange))
              ]),
              const Icon(Icons.compare_arrows, color: Colors.grey),
              Column(children: [
                const Text("GPS", style: TextStyle(color: Colors.green)), 
                Text("${gpsAcc.toStringAsFixed(1)} m", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green))
              ]),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            netAcc < gpsAcc 
            ? "Network lebih akurat (Khas Indoor)" 
            : "GPS lebih akurat (Khas Outdoor)",
            style: TextStyle(
              color: netAcc < gpsAcc ? Colors.orange[800] : Colors.green[800], 
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}