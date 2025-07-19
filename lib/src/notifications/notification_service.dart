import 'dart:math';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'game_notifications_channel';

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Madrid')); // ajusta a tu zona

    await _notificationsPlugin.initialize(initSettings);

    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        _channelId,
        'Game Notifications',
        description: 'Notificaciones del juego If Open, Lose',
        importance: Importance.high,
      );

      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }
  }

  static Future<void> requestPermissions() async {
    final iosPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> showStartNotification() async {
    const platformDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        'Game Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      0,
      'El juego ha comenzado',
      'Mantente firme. No abras esta app otra vez o perderás.',
      platformDetails,
    );
  }

  static Future<void> scheduleRandomNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyScheduled = prefs.getBool('notifications_scheduled') ?? false;

    if (alreadyScheduled) {
      print("Notificaciones ya programadas.");
      return;
    }

    final mensajes = await _fetchMessagesFromFirestore();
    if (mensajes.isEmpty) {
      print("No se encontraron mensajes.");
      return;
    }

    final now = DateTime.now();
    DateTime nextTime = now.add(const Duration(hours: 2));
    final random = Random();

    for (int i = 0; i < 30; i++) {
      final mensaje = mensajes[random.nextInt(mensajes.length)];

      try {
        await _notificationsPlugin.zonedSchedule(
          i + 1,
          'Juego en curso',
          mensaje,
          tz.TZDateTime.from(nextTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              'Game Notifications',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        print("Notificación $i programada para $nextTime");
      } catch (e) {
        print("Error programando notificación $i: $e");
      }

      final delayHours = 5 + random.nextInt(3); // entre 5 y 7 horas
      nextTime = nextTime.add(Duration(hours: delayHours));
    }

    await prefs.setBool('notifications_scheduled', true);
  }

  static Future<List<String>> _fetchMessagesFromFirestore() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('notificaciones').get();

      return snapshot.docs
          .map((doc) => doc.data()['mensaje'] as String)
          .where((m) => m.isNotEmpty)
          .toList();
    } catch (e) {
      print("Error obteniendo notificaciones: $e");
      return [];
    }
  }
}
