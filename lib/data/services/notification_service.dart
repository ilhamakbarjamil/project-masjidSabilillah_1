import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:masjid_sabilillah/core/constants/app_colors.dart';
import 'package:masjid_sabilillah/data/models/prayer_time_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Call this in main() after WidgetsFlutterBinding.ensureInitialized
  static Future<void> init() async {
    // Android Init
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Ganti ic_launcher jika ingin
    final DarwinInitializationSettings iosInitSettings =
        const DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    await _setupNotificationChannel();

    // iOS notification permission
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission();
    }

    // Inisialisasi timezone (untuk zoned notifications)
    tz.initializeTimeZones();
  }

  // Custom channel: themed for masjid
  static Future<void> _setupNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'masjid_announcement', // id
      'Pengumuman Masjid', // name
      description: 'Notifikasi pengumuman dan info masjid',
      importance: Importance.max,
      playSound: true,
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Show notification (local or push trigger)
  static Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    final notifAndroid = notification.android;

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'masjid_announcement',
      'Pengumuman Masjid',
      channelDescription: 'Pengumuman dari masjid dan jadwal penting',
      icon: notifAndroid?.smallIcon ?? '@mipmap/ic_launcher',
      color: AppColors.lightPrimary,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data['route'] ?? '',
    );
  }

  /// Listen and show for push notification
  static void listenToFirebase() {
    // Saat app di-foreground, tampilkan notifikasi lokal
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });
    // Saat app di background/terminated, FCM akan otomatis memunculkan notification jika tipe "notification".
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Aksi apabila user klik notifikasi (bisa digunakan untuk navigasi halaman tertentu nanti)
      // contoh: print('Dibuka dari notifikasi: \\${message.data}');
    });
  }

  /// Schedule local notification untuk setiap jadwal sholat hari ini
  static Future<void> schedulePrayerNotifications(PrayerTime prayerTime) async {
    // Batalkan semua jadwal notif sholat sebelumnya (ID 100-120) supaya tidak dobel
    for (int i = 0; i < 10; i++) {
      await _flutterLocalNotificationsPlugin.cancel(100 + i);
    }
    final List<Map<String, String>> prayers = prayerTime.prayerList;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentTZ = tz.local;

    for (final prayer in prayers) {
      final jadwal = prayer['time'];
      final nama = prayer['name'];
      if (jadwal == null) continue;
      final timeParts = jadwal.split(":");
      if (timeParts.length != 2) continue;
      final hour = int.tryParse(timeParts[0]) ?? 0;
      final minute = int.tryParse(timeParts[1]) ?? 0;
      final notifTime = DateTime(today.year, today.month, today.day, hour, minute);
      if (notifTime.isBefore(now)) continue; // skip jika waktu sholat sudah lewat hari ini
      final tzTime = tz.TZDateTime.from(notifTime, currentTZ);
      final androidDetails = AndroidNotificationDetails(
        'masjid_sholat',
        'Jadwal Sholat',
        channelDescription: 'Pengingat waktu sholat harian',
        icon: '@mipmap/ic_launcher',
        color: AppColors.lightPrimary,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );
      final iosDetails = DarwinNotificationDetails();
      final details = NotificationDetails(android: androidDetails, iOS: iosDetails);
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        100 + prayers.indexOf(prayer),
        'Waktunya Sholat $nama',
        'Sudah masuk waktu sholat $nama',
        tzTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: null,
        payload: 'prayer_$nama',
      );
    }
  }
}
