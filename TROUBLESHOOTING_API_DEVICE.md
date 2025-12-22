# Troubleshooting: API Jadwal Sholat Tidak Bekerja di Android Device

## Masalah
API jadwal sholat (aladhan.com) berfungsi di emulator tetapi tidak bekerja ketika aplikasi diinstall di Android device.

## Kemungkinan Penyebab

### 1. **Network Configuration Issues** (Android 9+)
Android 9+ memiliki security policy yang ketat untuk network connections. Masalah ini sering terjadi karena:
- Cleartext traffic tidak diizinkan oleh default di Android 9+
- Certificate validation failures
- TLS/SSL issues

**Solusi:** Network security config sudah ditambahkan di:
```
android/app/src/main/res/xml/network_security_config.xml
```

Pastikan AndroidManifest.xml sudah direferensikan:
```xml
<application
    ...
    android:networkSecurityConfig="@xml/network_security_config"
>
```

### 2. **Internet Permission**
Pastikan permission sudah ada di AndroidManifest.xml:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```
✅ Sudah ada di manifest.

### 3. **DNS Resolution Issues**
Device Android mungkin mengalami masalah DNS. Beberapa ISP memiliki DNS yang tidak stabil.

### 4. **Timeout Issues**
Request ke API mungkin timeout karena network yang lambat di device.

**Solusi:** Timeout sudah ditambahkan ke ApiService (30 detik).

### 5. **API Rate Limiting**
API aladhan.com memiliki rate limit. Jika terlalu banyak request, bisa diblokir.

## Solusi yang Sudah Diterapkan

### 1. **Updated API Service** ([lib/data/services/api_service.dart](lib/data/services/api_service.dart))
- Menambahkan timeout handling (30 detik)
- Better error messages untuk debugging
- Logging untuk semua requests
- Handling berbagai HTTP status codes

### 2. **Network Security Config** ([android/app/src/main/res/xml/network_security_config.xml](android/app/src/main/res/xml/network_security_config.xml))
- HTTPS-only untuk api.aladhan.com
- Trust system & user certificates untuk development
- Debug override untuk testing

### 3. **Network Diagnostic Service** ([lib/core/services/network_diagnostic_service.dart](lib/core/services/network_diagnostic_service.dart))
- Test connectivity status
- Test DNS resolution
- Test HTTPS connection
- Test API endpoint directly
- List network interfaces

### 4. **Network Diagnostic Screen** ([lib/presentation/screens/network_diagnostic_screen.dart](lib/presentation/screens/network_diagnostic_screen.dart))
- UI untuk menjalankan diagnostic tests
- Lihat detail hasil setiap test
- Refresh tests kapan saja

## Cara Testing

### 1. **Run Diagnostic Screen**
Tambahkan route ke navigation:
```dart
GetPage(
  name: '/network-diagnostic',
  page: () => const NetworkDiagnosticScreen(),
),
```

Atau tambahkan button di home screen untuk debug:
```dart
if (kDebugMode) {
  ElevatedButton(
    onPressed: () => Get.toNamed('/network-diagnostic'),
    child: const Text('Network Diagnostic'),
  ),
}
```

### 2. **Check Logs**
Jalankan di terminal:
```bash
flutter run -v
```

Cari output dari ApiService dengan prefix `[API Service]`

### 3. **Manual Testing**
Test dengan curl di device (jika ada access):
```bash
curl -v https://api.aladhan.com/v1/timingsByCity?city=Surabaya&country=ID&method=5
```

## Debugging Steps

### Step 1: Verify Network Connection
- Cek apakah device terhubung ke internet
- Coba buka browser dan akses website
- Cek WiFi/Mobile data settings

### Step 2: Check Logs
- Build dan run di Android device: `flutter run -v`
- Lihat console output untuk `[API Service]` logs
- Catat status code dan error message

### Step 3: Run Diagnostic
- Buka Network Diagnostic screen
- Lihat hasil setiap test (connectivity, DNS, HTTPS, API)
- Catat test yang gagal

### Step 4: Test API Directly
Jika DNS/HTTPS test pass tapi API test fail:
- Bisa masalah dengan API endpoint atau rate limiting
- Coba dengan domain/port berbeda di diagnostic service
- Coba test tanpa city parameter

### Step 5: Check Network Config
Pastikan network_security_config.xml benar:
- File ada di `android/app/src/main/res/xml/`
- AndroidManifest.xml merefensi network security config
- Rebuild app dengan `flutter clean && flutter pub get`

## Common Issues & Solutions

### Issue: "Masalah koneksi internet"
**Penyebab:** Device tidak terhubung atau DNS gagal
**Solusi:** 
- Cek Wi-Fi/Mobile data
- Restart device
- Coba ganti DNS (8.8.8.8 / 1.1.1.1)

### Issue: "API request timeout"
**Penyebab:** Network lambat atau server API down
**Solusi:**
- Cek kecepatan internet di device
- Coba di network berbeda
- Cek apakah api.aladhan.com bisa diakses via browser

### Issue: "Certificate validation error"
**Penyebab:** SSL/TLS issue
**Solusi:**
- Cek tanggal/waktu device (harus akurat)
- Restart app
- Rebuild dengan `flutter clean`

### Issue: "Error 429 - Terlalu banyak request"
**Penyebab:** API rate limit terlampaui
**Solusi:**
- Tunggu beberapa menit
- Jangan buka screen jadwal sholat berkali-kali
- Implement caching di app

## Next Steps

1. ✅ **Test di emulator** - Verify masih berfungsi
2. 🔄 **Build APK** - Dengan `flutter build apk --release`
3. 📱 **Install di device** - `flutter install`
4. 🧪 **Run diagnostic** - Check semua test status
5. 📊 **Collect logs** - `flutter run -v 2>&1 | grep "API Service"`

## Additional Resources

- [Android Network Security Configuration](https://developer.android.com/training/articles/security-config)
- [Flutter Networking Best Practices](https://docs.flutter.dev/cookbook/networking)
- [Aladhan API Docs](https://aladhan.com/api-details)

## Support
Jika masih error, berikan informasi:
- API Service log output
- Network Diagnostic test results
- Android version di device
- Network type (Wi-Fi/Mobile)
- Error message yang muncul di UI
