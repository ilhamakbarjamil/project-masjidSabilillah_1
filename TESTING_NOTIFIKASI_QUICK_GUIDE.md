# 🔔 QUICK START - TESTING NOTIFIKASI SHOLAT

**Waktu Setup:** 2 menit  
**Waktu Testing:** 5-10 menit  

---

## 🚀 STEP-BY-STEP (Cepat & Mudah)

### Step 1: Build & Run App
```bash
cd /home/zack/Documents/project-masjidSabilillah_1
flutter clean
flutter pub get
flutter run
```

### Step 2: Grant Notification Permission
Saat app pertama kali buka:
- ✅ Tap "Allow" ketika diminta notification permission
- Jika tidak muncul, manual enable di:
  - Settings → Apps → MySabilillah → Notifications → Allow

### Step 3: Navigate ke Test Screen
Ada 2 cara:

**Cara A: Langsung URL**
- App sudah tersedia, route: `/notification-test`
- Gunakan adb/flutter command:
  ```bash
  adb shell am start -n com.example.masjid_sabilillah/com.example.masjid_sabilillah.MainActivity
  ```

**Cara B: Tambah Button di Home** (Optional)
```dart
// Di HomeScreen, tambahkan:
ElevatedButton(
  onPressed: () => Get.toNamed('/notification-test'),
  child: const Text('🔔 Test Notifikasi'),
)
```

### Step 4: Test Notifikasi
Di test screen, ada tombol-tombol:

1. **Test Prayer Notifications**
   - Tap: "Subuh", "Dhuhur", "Ashar", "Maghrib", "Isya"
   - Notifikasi langsung muncul
   - Lihat icon, title, body

2. **Test Custom Notification**
   - Tap: "Test Custom Notifikasi"
   - Notifikasi custom message muncul

3. **Cancel All**
   - Tap: "Batalkan Semua Notifikasi"
   - Semua scheduled notification dihapus

---

## ✅ VERIFICATION CHECKLIST

Setelah test, verifikasi:

```
✓ Notifikasi muncul di notification center
✓ Icon terlihat (custom mosque icon)
✓ Title: "🕌 Waktunya Sholat [NAME]"
✓ Body: "Sudah masuk waktu sholat [NAME]. Yuk segera bersiap!"
✓ Sound/vibration terdengar/terasa
✓ Tap notifikasi membuka app
✓ App bisa di-background, notif tetap muncul
✓ Cancel all menghapus semua scheduled notif
```

---

## 📂 FILES YANG SUDAH SETUP

### Baru Dibuat:
1. **lib/presentation/screens/notification_test_screen.dart**
   - UI untuk test notifikasi
   - Button per-prayer time
   - Custom test & cancel functionality

### Modified:
1. **lib/data/services/notification_service.dart**
   - Enhanced dengan fitur lengkap
   - Improved error handling
   - Added test notification method

2. **lib/main.dart**
   - Add route `/notification-test`
   - NotificationService init & listen already set

3. **pubspec.yaml**
   - Add `timezone: ^0.9.4` dependency

### Documentation:
1. **NOTIFIKASI_SETUP_TESTING_GUIDE.md**
   - Complete setup guide
   - Troubleshooting
   - Customization options

---

## 🎯 AUTOMATIC FLOW (How It Works)

```
User buka Jadwal Sholat Screen
    ↓
API fetch jadwal sholat dari Anda (or hardcoded)
    ↓
PrayerTimesScreen call: NotificationService.schedulePrayerNotifications()
    ↓
Service loop through semua prayer times
    ↓
Cancel notifikasi lama (prevent duplicate)
    ↓
Schedule notifikasi baru untuk hari ini + esok hari
    ↓
Flutter local notifications handle scheduling
    ↓
At scheduled time → Notification muncul (foreground atau background)
    ↓
User notified! ✅
```

---

## 🧪 RECOMMENDED TEST SEQUENCE

1. **First Test:** Individual Prayer
   - Tap "Subuh" button
   - Verify notifikasi muncul
   - Check icon, title, body

2. **Second Test:** Custom Message
   - Tap "Test Custom Notifikasi"
   - Verify custom message works

3. **Third Test:** Real Jadwal
   - Go back, open Jadwal Sholat
   - Auto-schedule notifikasi untuk hari ini
   - Wait until prayer time (atau test dengan 1 min ahead)

4. **Fourth Test:** Background
   - Run app, go to test screen, tap test button
   - Tap home button (app di background)
   - Notifikasi harus tetap muncul

5. **Fifth Test:** Cancel
   - Go back to test screen
   - Tap "Batalkan Semua Notifikasi"
   - Verify all scheduled notif dibatalkan

---

## 🔧 QUICK TROUBLESHOOTING

| Issue | Solution |
|-------|----------|
| Notifikasi tidak muncul | Check permission granted, check do-not-disturb off |
| Error saat tap test button | Check console logs, restart app |
| Notifikasi dobel | App is working fine (old ones auto-cancelled) |
| Tidak ada icon | Custom icon sudah di-setup, check drawable |
| Sound tidak terdengar | Check device volume, notification channel settings |

---

## 📊 EXPECTED OUTPUT

Saat tap "Test Subuh":

```
System Notification:
┌─────────────────────────────────┐
│ 🕌 Waktunya Sholat Subuh       │  ← Icon + Title
│ Sudah masuk waktu sholat...    │  ← Body (bisa multi-line)
│ [Right Now]                      │  ← Time indicator
└─────────────────────────────────┘

Result in App:
✅ Green snackbar: "Notifikasi sholat Subuh berhasil ditampilkan!"
```

---

## 💡 PRO TIPS

1. **Test dengan Jadwal Nyata**
   ```dart
   // Buka Jadwal Sholat screen untuk auto-schedule
   // Notifikasi akan muncul di waktu sholat yang sebenarnya
   ```

2. **Test Timing**
   ```
   - Untuk test cepat: Ubah jadwal sholat ke 1 menit ke depan
   - Untuk test real: Biarkan auto-schedule dari API/jadwal sebenarnya
   ```

3. **Monitor Logs**
   ```bash
   flutter logs | grep "Notif"
   ```

4. **Check Device Settings**
   - Settings → Apps → MySabilillah → Notifications
   - Pastikan enabled & tidak di-mute

---

## ✨ WHAT'S NEXT

Setelah testing sukses:

1. **Optional: Customize Notifikasi**
   - Change title/body format
   - Add sound file (optional)
   - Customize colors

2. **Optional: Add to UI**
   - Add test button ke Settings screen
   - Show notification status
   - Allow user to enable/disable

3. **Ready for Production**
   - Remove test screen (atau hide)
   - Test dengan real device
   - Test notification dari FCM (optional)

---

## 📞 NEED HELP?

**See full guide:** `NOTIFIKASI_SETUP_TESTING_GUIDE.md`

**Common issues:**
- Permission not granted → Check Android settings
- App crashes → Check logs: `flutter logs`
- Notif doesn't appear → Try `flutter clean && flutter run`

---

## 🎉 YOU'RE READY!

Semua sudah siap untuk test! 

**Next action:** 
```bash
flutter run
# → Tap "Allow" untuk notification permission
# → Navigate ke test screen
# → Tap "Subuh" atau prayer lain
# → Verify notifikasi muncul ✅
```

**Happy testing!** 🚀
