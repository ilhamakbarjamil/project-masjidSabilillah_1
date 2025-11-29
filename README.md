# Location Tracking Experiments

Aplikasi Flutter untuk eksperimen tracking lokasi dengan Network dan GPS provider menggunakan arsitektur modular dengan GetX.

## Fitur

- **Live Location Tracking** - Real-time tracking dengan stream location updates
- **Network Location** - Provider network dengan akurasi rendah
- **GPS Location** - Provider GPS dengan akurasi tinggi
- **FlutterMap + OpenStreetMap** - Visualisasi peta interaktif
- **GetX State Management** - Manajemen state yang efisien
- **Arsitektur Modular** - Service, Controller, View terpisah

## Eksperimen

### Eksperimen 1: Outdoor (Statis)
- Catat lokasi di luar ruangan
- Bandingkan Network vs GPS
- Data yang dicatat: latitude, longitude, accuracy, timestamp

### Eksperimen 2: Indoor (Statis)
- Catat lokasi di dalam ruangan
- Bandingkan Network vs GPS dalam kondisi indoor
- Analisis perbedaan akurasi

### Eksperimen 3: Bergerak (Real-time)
- Live tracking saat bergerak
- Mode Network dan GPS
- Observasi:
  - Pergerakan marker (halus/melompat)
  - Kecepatan update
  - Respons posisi pertama
  - Jalur yang terbentuk

## Struktur Proyek

```
lib/
├── controllers/          # GetX Controllers
│   ├── location_controller.dart
│   └── experiment_controller.dart
├── models/              # Data Models
│   └── location_data.dart
├── services/            # Business Logic
│   └── location_service.dart
├── views/               # UI Screens
│   ├── home_view.dart
│   ├── outdoor_experiment_view.dart
│   ├── indoor_experiment_view.dart
│   └── moving_experiment_view.dart
├── widgets/             # Reusable Widgets
│   └── location_map.dart
└── main.dart
```

## Dependencies

- `geolocator` - Location services
- `permission_handler` - Permission management
- `get` - State management
- `flutter_map` - Map widget
- `latlong2` - Lat/Lng calculations
- `intl` - Date formatting

## Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Untuk Android, permissions sudah ditambahkan di `AndroidManifest.xml`

3. Untuk iOS, permissions sudah ditambahkan di `Info.plist`

4. Run aplikasi:
```bash
flutter run
```

## Penggunaan

1. Buka aplikasi dan pilih eksperimen yang ingin dilakukan
2. Untuk eksperimen statis (Outdoor/Indoor):
   - Tekan "Record Network" untuk mencatat lokasi dengan network provider
   - Tekan "Record GPS" untuk mencatat lokasi dengan GPS provider
   - Bandingkan hasil yang ditampilkan
3. Untuk eksperimen bergerak:
   - Pilih mode Network atau GPS
   - Aplikasi akan mulai tracking secara real-time
   - Amati pergerakan marker di peta
   - Tekan "Stop" untuk menghentikan tracking

## Catatan

- Pastikan GPS dan Internet aktif untuk hasil terbaik
- GPS memerlukan waktu untuk mendapatkan fix pertama (Time to First Fix)
- Network location lebih cepat tapi kurang akurat
- GPS lebih akurat tapi membutuhkan waktu lebih lama dan sinyal satelit yang baik
