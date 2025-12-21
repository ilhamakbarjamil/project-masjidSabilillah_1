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

  // Notification Channel IDs
  static const String _announcementChannelId = 'masjid_announcement';
  static const String _prayerChannelId = 'masjid_sholat';
  
  // Notification ID range untuk prayer times (100-109 untuk 5 sholat per hari)
  static const int _prayerNotificationIdStart = 100;

  /// Call this in main() after WidgetsFlutterBinding.ensureInitialized
  static Future<void> init() async {
    // Inisialisasi timezone terlebih dahulu
    tz.initializeTimeZones();
    
    // Android Init
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings iosInitSettings =
        const DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitSettings,
    );
    
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    await _setupNotificationChannels();

    // iOS notification permission
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission();
    }

    print('✅ NotificationService initialized');
  }

  // Setup notification channels untuk Android
  static Future<void> _setupNotificationChannels() async {
    // Channel untuk announcement
    const AndroidNotificationChannel announcementChannel = AndroidNotificationChannel(
      _announcementChannelId,
      'Pengumuman Masjid',
      description: 'Notifikasi pengumuman dan info penting dari masjid',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    
    // Channel untuk jadwal sholat
    const AndroidNotificationChannel prayerChannel = AndroidNotificationChannel(
      _prayerChannelId,
      'Jadwal Sholat',
      description: 'Pengingat waktu sholat harian - jangan lewatkan!',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );
    
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(announcementChannel);
    
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(prayerChannel);
  }

  // Callback ketika user tap notifikasi
  static void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload ?? '';
    print('🔔 Notifikasi di-tap: $payload');
    // Bisa digunakan untuk navigate ke screen tertentu jika diperlukan
  }

  /// Show notification (untuk remote message)
  static Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    final notifAndroid = notification.android;

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _announcementChannelId,
      'Pengumuman Masjid',
      channelDescription: 'Pengumuman dari masjid dan jadwal penting',
      icon: notifAndroid?.smallIcon ?? '@mipmap/ic_launcher',
      color: AppColors.lightPrimary,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    
    final DarwinNotificationDetails iosDetails = const DarwinNotificationDetails();
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

  /// Listen to Firebase Cloud Messaging
  static void listenToFirebase() {
    // Saat app di-foreground, tampilkan notifikasi lokal
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });
    
    // Saat app di background/terminated dan user klik notifikasi
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔔 App dibuka dari FCM notification: ${message.data}');
      // Bisa digunakan untuk navigasi halaman tertentu nanti
    });
  }

  /// Schedule local notification untuk SETIAP jadwal sholat hari ini & esok hari
  /// Jika ada perubahan jadwal, otomatis reschedule (tidak akan dobel)
  static Future<void> schedulePrayerNotifications(PrayerTime prayerTime) async {
    print('📅 Scheduling prayer notifications...');
    
    // Batalkan semua jadwal notif sholat sebelumnya (supaya tidak dobel)
    for (int i = 0; i < 10; i++) {
      await _flutterLocalNotificationsPlugin.cancel(_prayerNotificationIdStart + i);
    }
    
    final List<Map<String, String>> prayers = prayerTime.prayerList;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final currentTZ = tz.local;

    // Loop untuk 2 hari (hari ini + esok hari)
    for (final targetDate in [today, tomorrow]) {
      int notificationIndex = 0;
      
      for (final prayer in prayers) {
        final jadwal = prayer['time'];
        final nama = prayer['name'] ?? 'Sholat';
        
        if (jadwal == null) continue;
        
        final timeParts = jadwal.split(":");
        if (timeParts.length != 2) continue;
        
        final hour = int.tryParse(timeParts[0]) ?? 0;
        final minute = int.tryParse(timeParts[1]) ?? 0;
        
        final scheduledDateTime = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          hour,
          minute,
        );
        
        // Skip jika sudah lewat
        if (scheduledDateTime.isBefore(now)) continue;
        
        final tzTime = tz.TZDateTime.from(scheduledDateTime, currentTZ);
        
        final androidDetails = AndroidNotificationDetails(
          _prayerChannelId,
          'Jadwal Sholat',
          channelDescription: 'Pengingat waktu sholat harian',
          icon: '@mipmap/ic_launcher',
          color: AppColors.lightPrimary,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          styleInformation: const BigTextStyleInformation(
            'Sudah masuk waktu sholat. Jangan lewatkan!',
            contentTitle: 'Waktunya Sholat',
          ),
        );
        
        final iosDetails = const DarwinNotificationDetails(
          sound: 'notification.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
        
        final details = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );
        
        final notificationId = _prayerNotificationIdStart + notificationIndex;
        
        try {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId,
            '🕌 Waktunya Sholat $nama',
            'Sudah masuk waktu sholat $nama. Yuk segera bersiap!',
            tzTime,
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: null,
            payload: 'prayer_$nama',
          );
          print('✅ Notif sholat $nama scheduled untuk ${tzTime.toString()}');
        } catch (e) {
          print('❌ Error scheduling notif $nama: $e');
        }
        
        notificationIndex++;
      }
    }
  }

  /// Show custom local notification (untuk testing)
  static Future<void> showTestNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _prayerChannelId,
      'Test Notifikasi',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    final iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      999,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Cancel semua scheduled notifications
  static Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    print('❌ Semua scheduled notifications dibatalkan');
  }
}
