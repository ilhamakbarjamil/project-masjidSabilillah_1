# ✅ Implementation Checklist - API Jadwal Sholat Device Fix

## Files yang Sudah Dibuat/Diupdate

### ✅ Configuration Files
- [x] `android/app/src/main/res/xml/network_security_config.xml` (BARU)
- [x] `android/app/src/main/AndroidManifest.xml` (UPDATED)
- [x] `pubspec.yaml` (UPDATED - menambah connectivity_plus)

### ✅ Service Files
- [x] `lib/data/services/api_service.dart` (UPDATED - better error handling)
- [x] `lib/data/services/cached_api_service.dart` (BARU)
- [x] `lib/core/services/network_diagnostic_service.dart` (BARU)

### ✅ UI Files
- [x] `lib/presentation/screens/network_diagnostic_screen.dart` (BARU)
- [x] `lib/presentation/screens/prayer_times_screen.dart` (UPDATED - use cached service)

### ✅ Documentation
- [x] `TROUBLESHOOTING_API_DEVICE.md` (BARU)
- [x] `API_DEVICE_FIX_SUMMARY.md` (BARU - this file)

---

## 📋 Testing Checklist

### Pre-Testing
- [ ] Run `flutter clean`
- [ ] Run `flutter pub get`
- [ ] Verify Android build files:
  - [ ] `android/app/src/main/AndroidManifest.xml` has `android:networkSecurityConfig="@xml/network_security_config"`
  - [ ] `android/app/src/main/res/xml/network_security_config.xml` exists
  - [ ] File sudah di-save dengan format XML yang benar

### Emulator Testing
- [ ] Build & run di emulator: `flutter run`
- [ ] Test Jadwal Sholat screen - harus muncul data
- [ ] Check console logs untuk `[API Service]` messages
- [ ] Verify tidak ada error

### Device Testing
- [ ] Build APK: `flutter build apk --release`
- [ ] Install: `adb install build/app/outputs/flutter-app.apk`
- [ ] Open app di device
- [ ] Buka Jadwal Sholat screen

#### Scenario 1: Internet Available
- [ ] Jadwal sholat harus muncul
- [ ] Check logs: `flutter run -v` pada device
- [ ] Look for `[API Service]` success messages
- [ ] Check timestamps - harus hari ini

#### Scenario 2: Network Issue
- [ ] Disable internet di device (airplane mode)
- [ ] Buka Jadwal Sholat screen
- [ ] Harus muncul cached data dari visit sebelumnya
- [ ] Message harus user-friendly (bukan error crash)
- [ ] Enable internet kembali

#### Scenario 3: API Down
- [ ] Change city
- [ ] Try using VPN jika ada
- [ ] Check api.aladhan.com status via browser di device
- [ ] Verify cached data muncul sebagai fallback

### Diagnostic Testing
- [ ] Buat route ke NetworkDiagnosticScreen
- [ ] Run diagnostic dari device
- [ ] Dokumentasi hasil setiap test:
  - [ ] Connectivity Check - Status?
  - [ ] DNS Resolution - api.aladhan.com resolve?
  - [ ] HTTPS Connection - Port 443 connect?
  - [ ] API Endpoint - Status code 200?
  - [ ] Network Interfaces - Ada IP addresses?

### Logging
- [ ] Run: `flutter run -v 2>&1 | tee device_test.log`
- [ ] Buka Jadwal Sholat
- [ ] Save log file
- [ ] Check for:
  - [ ] `[API Service] Requesting: https://api.aladhan.com...`
  - [ ] `[API Service] Status Code: 200`
  - [ ] `[API Service] Response Body:` (preview data)
  - [ ] No `[API Service] Error:` messages

---

## 🔧 If Tests Fail

### Symptom: "Gagal memuat jadwal sholat" di device
**Checklist:**
- [ ] Android version >= 9 di device?
- [ ] Network security config file ada?
- [ ] AndroidManifest.xml reference benar?
- [ ] No syntax errors di XML files?
- [ ] Rebuild dengan `flutter clean && flutter pub get`

### Symptom: DNS Resolution Failed
**Checklist:**
- [ ] Device punya internet (test dengan browser)?
- [ ] Try change DNS: Settings > Network > Advanced > DNS
- [ ] Try Google DNS: 8.8.8.8, 8.8.4.4
- [ ] Restart device
- [ ] Check if ISP blocking api.aladhan.com

### Symptom: HTTPS Connection Failed
**Checklist:**
- [ ] Device date/time correct?
- [ ] Port 443 not blocked by firewall?
- [ ] WiFi vs Mobile data - test both?
- [ ] Try different network (hotspot)?

### Symptom: API Error (Status 4xx/5xx)
**Checklist:**
- [ ] Correct city name di local storage?
- [ ] Check city name di localStorage:
  ```bash
  adb shell "cat /data/data/com.example.masjid_sabilillah/shared_prefs/*.xml"
  ```
- [ ] API endpoint correct di code?
- [ ] Check aladhan.com status page

---

## 📊 Success Metrics

| Metric | Target | Status |
|--------|--------|--------|
| API works in emulator | ✅ Yes | ✅ Done |
| API works in device | ✅ Yes | 🔄 Testing |
| Cache fallback works | ✅ Yes | 🔄 Testing |
| Diagnostic tools work | ✅ Yes | 🔄 Testing |
| Error messages clear | ✅ Yes | ✅ Done |
| No crashes | ✅ Yes | 🔄 Testing |

---

## 📞 Support / Debug Info Needed

Jika masih tidak berhasil, kumpulkan:
1. Android version di device
2. Output dari Network Diagnostic screen
3. Full console log dari `flutter run -v`
4. Error message yang muncul di UI
5. Screenshots dari error/diagnostic

---

## 🎯 Final Steps

### When Everything Works ✅
1. [ ] Document hasil testing
2. [ ] Verify semua scenarios pass
3. [ ] Update version number di pubspec.yaml
4. [ ] Make git commit dengan message: "Fix: API jadwal sholat tidak bekerja di device - add network config, caching, diagnostics"
5. [ ] Build final APK: `flutter build apk --release`
6. [ ] Ready untuk production/distribution

### Next Phases (Optional)
- [ ] Add retry mechanism dengan exponential backoff
- [ ] Implement alternative API endpoints
- [ ] Add offline notification
- [ ] Implement local prayer time calculation
- [ ] Add Adhan sound notification

---

**Last Updated:** 2025-01-01
**Status:** Ready for Testing
**Assigned to:** Development Team
