# 🔔 NOTIFIKASI SHOLAT - SETUP & TESTING GUIDE

**Status:** ✅ Sudah di-implementasi  
**Terakhir Update:** 22 Desember 2025  
**Waktu Setup:** 5-10 menit  

---

## 📋 RINGKAS YANG SUDAH DILAKUKAN

### ✅ Diimplementasi:
1. **NotificationService** - Service lengkap untuk handle semua notifikasi
2. **Prayer Notifications** - Otomatis schedule notifikasi untuk setiap sholat
3. **Timezone Support** - Notifikasi tepat waktu dengan timezone awareness
4. **Test Screen** - UI untuk testing notifikasi sebelum production
5. **Multiple Channels** - Separate channels untuk announcement & prayer times

### 📦 Dependencies Ditambahkan:
```yaml
timezone: ^0.9.4  # Untuk schedule notifikasi dengan timezone yang akurat
```

---

## 🎯 FITUR NOTIFIKASI YANG SUDAH TERSEDIA

### 1. **Automatic Prayer Notifications**
- ✅ Notifikasi otomatis saat masuk waktu sholat
- ✅ Schedule untuk hari ini + esok hari
- ✅ Tidak akan dobel (auto-cancel notif lama saat reschedule)
- ✅ Bekerja bahkan app dalam background

### 2. **Firebase Cloud Messaging (FCM)**
- ✅ Listen untuk push notification dari Firebase
- ✅ Handle foreground & background messages
- ✅ Custom routing berdasarkan payload

### 3. **Local Notifications**
- ✅ Support Android & iOS
- ✅ Sound, vibration, & icon customization
- ✅ Notification channels untuk organization

### 4. **Test Notifications**
- ✅ Test per prayer time
- ✅ Custom message testing
- ✅ Cancel all functionality

---

## 🚀 SETUP REQUIREMENTS

### Android (AndroidManifest.xml)
Pastikan sudah ada di `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

✅ **Status:** Sudah ada di project

### iOS (Info.plist)
Pastikan sudah ada di `ios/Runner/Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
    <string>processing</string>
</array>
```

---

## ⚙️ CURRENT SETUP STATUS

### NotificationService Methods:

```dart
// 1. Initialize (dipanggil di main.dart)
NotificationService.init()

// 2. Listen to Firebase (dipanggil di main.dart)
NotificationService.listenToFirebase()

// 3. Schedule prayer notifications (otomatis dari PrayerTimesScreen)
NotificationService.schedulePrayerNotifications(prayerTime)

// 4. Show test notification (untuk testing)
NotificationService.showTestNotification(title, body, payload)

// 5. Cancel all notifications
NotificationService.cancelAllNotifications()
```

### Automatic Flow:

```
User buka PrayerTimesScreen
       ↓
API fetch jadwal sholat
       ↓
schedulePrayerNotifications() dipanggil otomatis
       ↓
Notifikasi dijadwalkan untuk setiap prayer time
       ↓
Saat waktu sholat tiba → Notifikasi muncul
```

---

## 🧪 TESTING NOTIFIKASI

### Method 1: Menggunakan Test Screen (RECOMMENDED)

**Step 1: Buka Test Screen**

Navigasi ke `/notification-test` di app, atau tambahkan button di home:

```dart
ElevatedButton(
  onPressed: () => Get.toNamed('/notification-test'),
  child: const Text('Test Notifikasi'),
)
```

**Step 2: Test Individual Prayer Notifications**

1. Tap tombol "Subuh", "Dhuhur", "Ashar", "Maghrib", atau "Isya"
2. Notifikasi akan muncul langsung di device
3. Lihat apakah:
   - ✅ Notifikasi muncul dengan icon yang benar
   - ✅ Title & body terlihat jelas
   - ✅ Sound/vibration berfungsi

**Step 3: Test Custom Notification**

1. Tap "Test Custom Notifikasi"
2. Lihat apakah notifikasi custom message muncul

**Step 4: Test Cancel**

1. Tap "Batalkan Semua Notifikasi"
2. Verify semua scheduled notif dihapus

---

### Method 2: Manual Testing dengan Kode

Tambahkan button di settings screen atau home untuk testing:

```dart
// Test single prayer
ElevatedButton(
  onPressed: () {
    NotificationService.showTestNotification(
      title: '🕌 Waktunya Sholat Ashar',
      body: 'Sudah masuk waktu sholat Ashar. Yuk segera bersiap!',
      payload: 'prayer_ashar',
    );
  },
  child: const Text('Test Notif Ashar'),
),

// Test custom
ElevatedButton(
  onPressed: () {
    NotificationService.showTestNotification(
      title: '✨ Test Custom Notifikasi',
      body: 'Ini adalah notifikasi test untuk MySabilillah',
      payload: 'custom',
    );
  },
  child: const Text('Test Custom'),
),
```

---

### Method 3: Real Prayer Time Testing

**Scenario: Schedule notifikasi untuk 1 menit ke depan**

```dart
// Di PrayerTimesScreen atau debug screen
void testPrayerNotificationIn1Minute() {
  final now = DateTime.now();
  final testTime = now.add(const Duration(minutes: 1));
  
  final prayerTime = PrayerTime(
    prayerList: [
      {
        'name': 'Test Sholat',
        'time': '${testTime.hour}:${testTime.minute}',
      }
    ],
  );
  
  NotificationService.schedulePrayerNotifications(prayerTime);
  
  print('✅ Notifikasi akan muncul pada ${testTime.toString()}');
}
```

---

## 🔍 VERIFICATION CHECKLIST

### Android Testing:

```
✓ Notification permission diminta saat app pertama kali
✓ Notifikasi muncul di notification center
✓ Notifikasi muncul saat app di-background
✓ Icon yang ditampilkan adalah custom app icon
✓ Sound/vibration terjadi (sesuai setting)
✓ Title & body text terlihat lengkap
✓ Tap notifikasi membuka app (jika ada payload handler)
```

### iOS Testing:

```
✓ Notification permission dialog muncul
✓ Notifikasi muncul di lock screen
✓ Notifikasi muncul di notification center
✓ Sound/haptics terjadi (sesuai setting)
✓ Badge count update
```

---

## 🐛 TROUBLESHOOTING

### Problem: Notifikasi tidak muncul

**Solusi:**
1. Cek notification permission:
   ```dart
   final status = await Permission.notification.status;
   print('Permission status: $status');
   ```

2. Cek Android notification settings:
   - Settings → Apps → MySabilillah → Notifications → Enabled

3. Bersihkan build & rebuild:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Problem: Notifikasi muncul tapi tidak ada sound

**Solusi:**
1. Pastikan device tidak dalam silent mode
2. Cek Android notification channel setting
3. Cek iOS notification settings di System Preferences

### Problem: Notifikasi scheduled tapi tidak muncul di waktu yang tepat

**Solusi:**
1. Pastikan timezone sudah diinisialisasi:
   ```dart
   tz.initializeTimeZones();
   ```

2. Cek timezone device:
   ```dart
   print('Current timezone: ${tz.local.name}');
   ```

3. Pastikan time calculation benar di `schedulePrayerNotifications()`

---

## 📝 IMPLEMENTATION DETAILS

### NotificationService Architecture:

```
NotificationService
├── init()
│   ├── Initialize FlutterLocalNotificationsPlugin
│   ├── Setup Android & iOS initialization settings
│   └── Initialize timezone (tz.initializeTimeZones())
│
├── _setupNotificationChannels()
│   ├── Create 'masjid_announcement' channel
│   ├── Create 'masjid_sholat' channel (prayer specific)
│   └── Configure sound, vibration, importance
│
├── schedulePrayerNotifications(PrayerTime)
│   ├── Cancel previous notifications (prevent duplicate)
│   ├── Loop through prayer list
│   ├── Calculate scheduled datetime
│   ├── Convert to TZDateTime (timezone-aware)
│   └── Schedule with zonedSchedule()
│
├── showNotification(RemoteMessage)
│   └── Show remote notification as local notification
│
├── showTestNotification(title, body)
│   └── Show immediate notification (for testing)
│
└── listenToFirebase()
    ├── Listen onMessage (app foreground)
    └── Listen onMessageOpenedApp (app background/killed)
```

### Prayer Notification Details:

**Title Format:**
```
🕌 Waktunya Sholat [PRAYER_NAME]
```

**Body Format:**
```
Sudah masuk waktu sholat [PRAYER_NAME]. Yuk segera bersiap!
```

**Payload:**
```
prayer_[PRAYER_NAME]  // e.g., prayer_ashar
```

---

## 🔧 CUSTOMIZATION GUIDE

### Mengubah Notifikasi Sound:

1. Tambahkan audio file ke:
   - Android: `android/app/src/main/res/raw/prayer_alarm.mp3`
   - iOS: `ios/Runner/Assets.xcassets/`

2. Update NotificationService:
   ```dart
   sound: RawResourceAndroidNotificationSound('prayer_alarm'),
   ```

### Mengubah Notifikasi Title/Body:

Edit di NotificationService method `schedulePrayerNotifications()`:

```dart
await _flutterLocalNotificationsPlugin.zonedSchedule(
  notificationId,
  '🕌 Waktunya Sholat $nama',  // <- Edit title di sini
  'Custom body text...',         // <- Edit body di sini
  tzTime,
  details,
  // ...
);
```

### Mengubah Vibration Pattern:

```dart
vibrationPattern: [0, 500, 250, 500],  // [delay, vibrate, pause, vibrate]
```

---

## 📊 SCHEDULING LOGIC

### Current Logic:

```dart
// Schedule untuk hari ini + esok hari
for (final targetDate in [today, tomorrow]) {
  for (final prayer in prayers) {
    // Calculate time
    // Skip if already passed
    // Schedule notification
  }
}
```

### Keuntungan:

- ✅ Notifikasi tersedia setiap hari (automatic)
- ✅ Tidak perlu update manual setiap hari
- ✅ Tidak akan dobel (auto-cancel old)
- ✅ Timezone-aware (jika timezone berubah)

---

## 🚀 PRODUCTION CHECKLIST

Sebelum release ke production:

```
[ ] Test semua 5 prayer notifications
[ ] Test di Android & iOS device (bukan emulator)
[ ] Cek notification permission flow
[ ] Cek notification settings di system
[ ] Test background notification
[ ] Test terminated app notification
[ ] Verify sound/vibration berfungsi
[ ] Cek notification tidak crash app
[ ] Test Firebase Cloud Messaging (jika ada)
[ ] Remove test screen atau disable di production
```

---

## 📚 FILE REFERENCES

### Files Modified/Created:

1. **lib/data/services/notification_service.dart** (Enhanced)
   - Complete rewrite dengan fitur lengkap
   - Added test notification method
   - Added cancel all method
   - Better error handling & logging

2. **lib/presentation/screens/notification_test_screen.dart** (New)
   - UI untuk testing notifikasi
   - Test buttons untuk setiap sholat
   - Custom test message
   - Cancel all functionality

3. **lib/main.dart** (Updated)
   - Import NotificationTestScreen
   - Add route '/notification-test'
   - Already has NotificationService init & listen

4. **pubspec.yaml** (Updated)
   - Add `timezone: ^0.9.4` dependency

### Dependencies:

```yaml
firebase_core: ^4.2.1              # Firebase initialization
firebase_messaging: ^16.0.4        # Cloud Messaging
flutter_local_notifications: ^17.2.3  # Local notifications
timezone: ^0.9.4                   # Timezone handling
permission_handler: ^11.3.1        # Permission management
```

---

## ✅ TESTING STEPS (QUICK REFERENCE)

### Quick Test Flow:

```
1. flutter clean && flutter pub get
2. flutter run
3. Grant notification permission when asked
4. Navigate to '/notification-test' (or add button)
5. Tap "Test Subuh" (or any prayer)
6. Verify notifikasi muncul
7. Check icon, title, body, sound/vibration
8. Test cancel all
9. Test custom notification
10. Done! ✅
```

### Debugging:

```bash
# Check permission status
adb shell am start -n com.android.settings/.permission.manage.RequestPermissionActivity

# Check notification channel
adb shell dumpsys notification

# View logs
flutter logs  # Real-time logs
```

---

## 🎓 LEARNING RESOURCES

### Key Concepts:

1. **Timezone-aware Scheduling**
   - `tz.TZDateTime` untuk handle timezone
   - `tz.local` untuk device timezone

2. **Notification Channels (Android)**
   - Separate channels untuk different notification types
   - User dapat mengatur per-channel settings

3. **Background Execution**
   - Local notifications bekerja di background
   - FCM push notifications handled by system

4. **Permission Model (Android 13+)**
   - `POST_NOTIFICATIONS` permission required
   - User dapat allow/deny per-app

---

## 🎉 YOU'RE READY!

Notifikasi sholat sudah fully implemented & siap untuk testing!

### Next Steps:

1. **Test di Emulator/Device:**
   ```bash
   flutter run
   ```

2. **Navigate ke Test Screen:**
   - Route: `/notification-test`

3. **Test All Features:**
   - Individual prayer notifications
   - Custom messages
   - Cancel functionality

4. **Monitor Logs:**
   ```bash
   flutter logs | grep "Notif"
   ```

5. **Check Device Notifications:**
   - Pull down notification center
   - Verify custom icon & messages

---

## 📞 SUPPORT

**If something doesn't work:**

1. Check `flutter logs` untuk error messages
2. Verify permission sudah granted
3. Check notification settings di device
4. Cek timezone configuration
5. Try `flutter clean && flutter pub get && flutter run`

**Common Issues:**

- Notif tidak muncul → Check permission
- Notif muncul lambat → Check timezone
- Notif dobel → Check cancel logic
- Crash saat notif → Check payload/callback

---

**Status: ✅ READY FOR TESTING**

Semua sudah siap! Langsung test di device/emulator Anda! 🚀

