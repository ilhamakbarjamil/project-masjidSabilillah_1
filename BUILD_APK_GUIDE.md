# 🚀 CARA REBUILD & INSTALL APK DENGAN PERBAIKAN JADWAL SHOLAT

## 📋 PRE-REQUISITES
- Flutter SDK sudah installed
- Android SDK sudah installed  
- Device/Emulator Android sudah siap

---

## ✅ STEP-BY-STEP BUILD APK

### **STEP 1: Clean Previous Build**
```bash
# Terminal di folder project root
flutter clean
rm -rf android/build
rm -rf build
flutter pub get
```

### **STEP 2: Update gradle (opsional tapi recommended)**
```bash
cd android
./gradlew --version  # Cek gradle version
cd ..
```

### **STEP 3: Build APK Release**

#### **Option A: Build APK saja** (Recommended untuk test)
```bash
flutter build apk --release
```
✅ APK akan di: `build/app/outputs/flutter-apk/app-release.apk`

#### **Option B: Build dengan verbose** (Untuk debug jika ada error)
```bash
flutter build apk --release -v
```

#### **Option C: Build Bundle** (Untuk Google Play Store)
```bash
flutter build appbundle --release
```

---

## 📲 STEP 4: INSTALL APK KE DEVICE

### **Option A: Via Flutter**
```bash
flutter install --release
```

### **Option B: Via ADB** 
```bash
# List devices
adb devices

# Install
adb install build/app/outputs/flutter-apk/app-release.apk

# Atau jika sudah ada, replace dengan -r flag
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### **Option C: Manual**
1. Copy file APK ke device
2. Open file manager di device
3. Tap APK file → Install

---

## 🧪 STEP 5: TEST DI DEVICE

### **Test 1: Buka App**
```bash
# Monitor logs while app runs
flutter logs
```

### **Test 2: Buka Jadwal Sholat**
1. Tap "Jadwal Sholat" menu
2. Tunggu data load
3. Cek logs untuk messages:
   ```
   [API Service] 📡 Requesting: ...
   [API Service] ✅ API Success!
   [CachedApiService] ✅ Berhasil fetch dari API
   ```

### **Test 3: Simulasi Network Buruk**
1. Turn off WiFi, gunakan mobile data
2. Atau: `adb shell cmd ipv4 ip-rule add` untuk simulate latency
3. Cek apakah fallback (cache/mock) bekerja

### **Test 4: Test Cache**
1. Close app
2. Turn off internet
3. Open app → Jadwal Sholat
4. Harus muncul cached data ✅

### **Test 5: Test Mock Data** 
1. Clear app data: `adb shell pm clear com.example.masjid_sabilillah`
2. Turn off internet
3. Open app → Jadwal Sholat
4. Harus muncul mock data dengan note

---

## 🔍 MONITORING & DEBUGGING

### **Watch Logs Real-time**
```bash
flutter logs | grep -E "API Service|CachedApiService|NetworkDiagnostics"
```

### **Test Network Diagnostic** (dari app)
Tambahkan temporary button di Home Screen:
```dart
// Temporary - untuk testing saja
FloatingActionButton(
  onPressed: () async {
    final results = await NetworkDiagnostics.runFullDiagnostic();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Diagnostics: $results'))
    );
  },
  child: const Icon(Icons.wifi_tethering),
)
```

### **Extract & Check APK**
```bash
# List files dalam APK
unzip -l build/app/outputs/flutter-apk/app-release.apk | grep network_security

# Check manifest
unzip -p build/app/outputs/flutter-apk/app-release.apk AndroidManifest.xml | grep -i internet
```

---

## ⚠️ COMMON BUILD ERRORS & SOLUTIONS

### **Error: "Certificate error" atau SSL_HANDSHAKE_FAILURE"**
```
❌ Penyebab: Network security config tidak benar
✅ Solusi: 
   - Cek android/app/src/main/res/xml/network_security_config.xml
   - Pastikan ada <trust-anchors> dengan certificates src="system"
   - Re-build APK
```

### **Error: "Request timeout"**
```
❌ Penyebab: Timeout terlalu pendek atau jaringan lambat
✅ Solusi:
   - Sudah dinaikkan ke 30s di api_service.dart ✅
   - Test dengan mobile data atau slow WiFi
```

### **Error: "Gradle compilation failed"**
```bash
❌ Penyebab: Dependencies conflict atau gradle issue
✅ Solusi:
   flutter clean
   rm -rf android/.gradle
   flutter pub get
   cd android && ./gradlew build && cd ..
```

### **APK besar (> 100MB)?**
```
❌ Penyebab: Debug symbols tidak dihapus
✅ Solusi:
   # sudah ada di build.gradle.kts:
   isMinifyEnabled = false  # OK karena masih small
   
   # Jika perlu optimize lebih:
   # isMinifyEnabled = true
   # shrinkResources = true
```

---

## 📊 VERIFICATION CHECKLIST

Sebelum release ke user/PlayStore:

- [ ] APK berhasil build tanpa error
- [ ] APK berhasil install di device
- [ ] Jadwal Sholat muncul dengan benar
- [ ] Log menunjukkan API fetch berhasil
- [ ] Test dengan jaringan buruk - fallback bekerja
- [ ] App tidak crash saat network error
- [ ] Back button dari Jadwal Sholat bekerja
- [ ] City selector berfungsi

---

## 🎯 QUICK COMMAND CHEATSHEET

```bash
# Clean everything
flutter clean && flutter pub get

# Build only
flutter build apk --release

# Build + Install in one command
flutter install --release

# Watch logs
flutter logs

# Uninstall app
adb uninstall com.example.masjid_sabilillah

# Check installed packages
adb shell pm list packages | grep masjid

# View device storage
adb shell df -h

# Clear app data
adb shell pm clear com.example.masjid_sabilillah
```

---

## 📞 JIKA MASIH GAGAL

1. **Share error message lengkap** dari:
   ```bash
   flutter build apk --release -v
   ```

2. **Share logs** dari:
   ```bash
   flutter logs
   ```
   (setelah app buka dan akses Jadwal Sholat)

3. **Check device info**:
   ```bash
   adb shell getprop ro.build.version.release  # Android version
   adb shell getprop ro.product.model          # Device model
   ```

---

**Last Updated**: 2025-12-22
**Status**: Ready to build ✅
