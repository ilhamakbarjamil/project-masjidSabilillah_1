# 🚀 Quick Start - API Jadwal Sholat Device Fix

## Masalah
Jadwal sholat tidak muncul di Android device (real phone), tapi berfungsi di emulator.

## Solusi Cepat (3 Langkah)

### 1️⃣ Update Dependencies
```bash
flutter pub get
```

### 2️⃣ Clean Build
```bash
flutter clean
flutter pub get
```

### 3️⃣ Build & Test
```bash
# Test di device
flutter run

# Atau build APK
flutter build apk --release
adb install build/app/outputs/flutter-app.apk
```

---

## ✨ Apa yang Sudah Diperbaiki?

✅ **Network Security Config** - Handle Android 9+ SSL/TLS issues
✅ **Better Error Messages** - Clear messages untuk debugging
✅ **Timeout Handling** - Prevent request hanging (30 detik timeout)
✅ **Cache Fallback** - Jadwal tetap muncul meski internet fail
✅ **Diagnostic Tools** - Test connectivity step-by-step
✅ **Improved Logging** - Track setiap API call

---

## 🧪 Cara Testing

### Jika Masih Error
1. Buka **Network Diagnostic** screen (jika sudah di-link)
2. Lihat hasil setiap test
3. Cek mana yang fail: DNS? HTTPS? API?
4. Follow solusi di **TROUBLESHOOTING_API_DEVICE.md**

### Jika Berhasil ✅
- Jadwal sholat muncul normal
- Tidak ada error messages
- Cached data berfungsi saat offline

---

## 📁 Key Files Modified

| File | Status | Purpose |
|------|--------|---------|
| `android/app/src/main/res/xml/network_security_config.xml` | ✨ NEW | Network security config |
| `android/app/src/main/AndroidManifest.xml` | 🔄 UPDATED | Reference network config |
| `lib/data/services/api_service.dart` | 🔄 UPDATED | Better error handling |
| `lib/data/services/cached_api_service.dart` | ✨ NEW | Cache fallback |
| `lib/presentation/screens/prayer_times_screen.dart` | 🔄 UPDATED | Use cached service |
| `lib/core/services/network_diagnostic_service.dart` | ✨ NEW | Diagnostic tools |
| `lib/presentation/screens/network_diagnostic_screen.dart` | ✨ NEW | Diagnostic UI |
| `pubspec.yaml` | 🔄 UPDATED | Add connectivity_plus |

---

## 🔧 Configuration

**Android Network Security:**
```xml
<!-- File: android/app/src/main/res/xml/network_security_config.xml -->
✅ HTTPS-only untuk api.aladhan.com
✅ Trust system certificates
✅ Debug override untuk development
```

**API Service:**
```dart
// lib/data/services/api_service.dart
✅ Timeout: 30 detik
✅ Detailed error messages
✅ Comprehensive logging
```

**Cache Service:**
```dart
// lib/data/services/cached_api_service.dart
✅ Try API first
✅ Fallback ke cache jika API fail
✅ 24-jam cache validity
```

---

## 📊 Expected Results

### ✅ Success Case
```
[API Service] Requesting: https://api.aladhan.com/v1/timingsByCity?...
[API Service] Status Code: 200
[API Service] Response Body: {"code":200,"status":"OK","data":{"timings":{...
```

### ❌ Error Case (dengan Fallback)
```
[API Service] Error: Network timeout
[CachedApiService] API failed: ..., trying cache...
[CachedApiService] Using cached data
→ UI menampilkan cached jadwal sholat (data sebelumnya)
```

---

## 🆘 Quick Troubleshooting

| Problem | Quick Fix |
|---------|-----------|
| "Gagal memuat jadwal sholat" | Run diagnostic, check connectivity |
| API timeout | Check internet speed, wait 30 detik |
| Empty data di UI | Verify city name di localStorage, check API response |
| App crash | Run `flutter clean`, rebuild |

Untuk penjelasan lengkap → **TROUBLESHOOTING_API_DEVICE.md**

---

## 📱 Device Requirements

- ✅ Android 9+ (SDK 28+)
- ✅ Internet connection (WiFi atau Mobile)
- ✅ Modern WebKit (untuk HTTPS)

---

## 🎯 Success Indicators

- ✅ Jadwal sholat muncul di device
- ✅ Tidak ada error toast/dialog
- ✅ Data sesuai dengan kota yang dipilih
- ✅ Cache working (test dengan offline)

---

## 📚 Documentation

- **TROUBLESHOOTING_API_DEVICE.md** - Complete guide
- **API_DEVICE_FIX_SUMMARY.md** - Implementation details
- **IMPLEMENTATION_CHECKLIST_API_FIX.md** - Testing checklist

---

## 🔗 Useful Commands

```bash
# Clean everything
flutter clean && flutter pub get

# Run with verbose logs
flutter run -v 2>&1 | grep "API Service\|CachedApiService"

# Build APK for testing
flutter build apk --release

# Install APK
adb install build/app/outputs/flutter-app.apk

# View device logs in real-time
adb logcat | grep "API Service"

# Check localStorage (requires root/emulator)
adb shell "cat /data/data/com.example.masjid_sabilillah/shared_prefs/*.xml"
```

---

## 💡 Tips

1. **Always test di device** - Emulator tidak selalu mencerminkan real device behavior
2. **Check multiple scenarios** - Dengan internet, tanpa internet, API down
3. **Read error messages** - Error messages sekarang jauh lebih descriptive
4. **Use diagnostic tools** - Penting untuk identify mana part yang fail
5. **Check logs** - `flutter run -v` adalah friend terbaik

---

**Status:** ✅ Ready to Deploy
**Last Updated:** 2025-01-01
**Questions?** Check TROUBLESHOOTING_API_DEVICE.md
