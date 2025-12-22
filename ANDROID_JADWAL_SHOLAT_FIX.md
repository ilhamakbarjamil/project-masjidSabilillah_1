# 🔧 TROUBLESHOOTING JADWAL SHOLAT DI ANDROID

## ❌ Masalah
- Jadwal Sholat tidak keluar di APK Android yang sudah di-install
- Error "Gagal memuat jadwal sholat"
- Padahal internet bagus

## ✅ SOLUSI YANG SUDAH DITERAPKAN

### 1️⃣ **Network Security Config** ✅
**File**: `android/app/src/main/res/xml/network_security_config.xml`
- ✅ Menambah domain fallback untuk HTTPS
- ✅ Mengizinkan koneksi ke semua `.com` domain
- ✅ Keep debug overrides untuk testing

### 2️⃣ **API Service Timeout** ✅
**File**: `lib/data/services/api_service.dart`
- ✅ Naikkan timeout dari 10s → 30s (Android lebih lambat)
- ✅ Tambah headers HTTP Accept & Accept-Encoding
- ✅ Improve error messages dengan emoji untuk clarity

### 3️⃣ **Cached API Service** ✅
**File**: `lib/data/services/cached_api_service.dart`
- ✅ Better fallback logic: API → Cache → Mock Data
- ✅ More detailed logging untuk debugging

### 4️⃣ **Prayer Times Screen UI** ✅
**File**: `lib/presentation/screens/prayer_times_screen.dart`
- ✅ Improve error state dengan helpful tips
- ✅ Tambah "Kembali ke Home" button

---

## 🧪 TESTING STEPS

### Step 1: Clean Build
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
```

### Step 2: Build APK untuk Testing
```bash
flutter build apk --release
```

### Step 3: Install & Test di Device
```bash
flutter install --release
# Atau buka APK di: build/app/outputs/flutter-apk/app-release.apk
```

### Step 4: Monitor Logs
```bash
flutter logs
```
Cari log messages:
```
[API Service] 📡 Requesting: ...
[API Service] ✅ API Success! Jadwal sholat berhasil dimuat.
[CachedApiService] ✅ Berhasil fetch dari API dan cache
```

---

## 🔍 DEBUGGING - JIKA MASIH ERROR

### Kemungkinan 1: **Masalah Jaringan Android**

**Ciri:**
- Error: "Masalah koneksi internet"
- API fail tapi cache/mock show

**Solusi:**
1. Cek `AndroidManifest.xml` sudah punya:
   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
   ```

2. Request network permission di code:
   ```dart
   // Di main.dart ditambahkan:
   if (await Permission.notification.isDenied) {
     await Permission.notification.request();
   }
   ```

3. Cek Network Security Config valid di release build:
   - Harus di: `android/app/src/main/res/xml/network_security_config.xml`
   - Reference di AndroidManifest sudah ada ✅

### Kemungkinan 2: **DNS Resolution Gagal**

**Ciri:**
- Timeout terus
- Jaringan normal di browser

**Solusi:**
1. Coba endpoint alternatif dalam API:
   ```dart
   // Tambahkan di api_service.dart:
   static const List<String> baseUrls = [
     'https://api.aladhan.com/v1/timingsByCity',
     'https://api.aladhanjs.com/v1/timingsByCity', // alternative
   ];
   ```

2. Implementasi retry logic:
   ```dart
   // Retry up to 3 times
   for (int retry = 0; retry < 3; retry++) {
     try {
       return await getPrayerTimes(...);
     } catch (e) {
       if (retry < 2) await Future.delayed(Duration(seconds: 2));
     }
   }
   ```

### Kemungkinan 3: **API Response Format Berbeda**

**Ciri:**
- Status 200 tapi error di JSON parsing
- Log: "JSON Parse Error"

**Solusi:**
1. Print full response:
   ```dart
   if (response.statusCode == 200) {
     print('[API] Full response: ${response.body}');
     // Parse sesuai actual format
   }
   ```

2. Update model jika format API berubah

### Kemungkinan 4: **Release Build Obfuscation**

**Ciri:**
- Debug mode jalan, release mode error
- Networking/JSON parsing fail

**Solusi:**
- ✅ `android/app/build.gradle.kts` sudah set: `isMinifyEnabled = false`
- ✅ ProGuard rules di `android/app/proguard-rules.pro` sudah protect network classes

---

## 📋 CHECKLIST SEBELUM RELEASE

- [ ] `network_security_config.xml` sudah diupdate
- [ ] `api_service.dart` timeout = 30s
- [ ] `cached_api_service.dart` punya fallback logic
- [ ] `AndroidManifest.xml` punya INTERNET permission
- [ ] Build file tidak ada shrinking (minifyEnabled = false)
- [ ] Test di beberapa devices
- [ ] Test dengan network yang buruk (WiFi limitation)

---

## 📝 LOG MESSAGES GUIDE

| Log | Status | Artinya |
|-----|--------|---------|
| `📡 Requesting: ...` | Info | API sedang request |
| `✅ API Success!` | Good | API berhasil, jadwal loaded |
| `⚠️ API failed: ...` | Warning | API gagal, try fallback |
| `💾 Mencoba gunakan cache` | Info | Fallback ke cache |
| `✅ Gunakan data dari cache` | Good | Cache dipakai |
| `🎯 Gunakan data mock` | Good | Mock data dipakai (temporary) |
| `❌` dengan pesan | Error | Ada error, perlu investigate |

---

## 🚀 NEXT STEPS

Jika masih error setelah semua langkah di atas:

1. **Share log output** dari: `flutter logs`
2. **Cek device**: Android version berapa?
3. **Test offline**: Apakah cache/mock data berfungsi?
4. **Contact API**: Cek status https://api.aladhan.com

---

## 📞 UNTUK TESTING CEPAT

Gunakan test screen yang sudah ada:
```dart
Get.offNamed('/notification-test');
```

Atau tambahkan button di Home untuk test API langsung:
```dart
FloatingActionButton(
  onPressed: () async {
    final api = ApiService();
    try {
      final result = await api.getPrayerTimes(city: 'Jakarta');
      print('✅ API Test Success: ${result.tanggal}');
    } catch (e) {
      print('❌ API Test Failed: $e');
    }
  },
  child: const Icon(Icons.api),
)
```

---

**Last Updated**: 2025-12-22
**Status**: Ready for testing ✅
