import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../firebase/firebase_service.dart';
import '../firebase/user_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = DarwinInitializationSettings();
    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission();
  }

  static Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static Future<void> updateTokenInFirestore(Usuario usuario) async {
    final token = await getFcmToken();
    if (token != null && token != usuario.fcmToken) {
      final firebaseService = FirebaseService();
      await firebaseService.actualizarFcmToken(usuario.id, token);
    }
  }

  static Future<void> showStartNotification(BuildContext context,
      {String? tema}) async {
    // Personaliza el contenido y estilo según el tema recibido (opcional)
    final androidDetails = AndroidNotificationDetails(
      'start_channel',
      'Start Notifications',
      channelDescription: 'Notificaciones al iniciar el juego',
      importance: Importance.max,
      priority: Priority.high,
      color: tema != null ? Color(_getColorFromTema(tema)) : null,
    );
    final iosDetails = DarwinNotificationDetails();
    final notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    final l10n = AppLocalizations.of(context)!;

    await _flutterLocalNotificationsPlugin.show(
      0,
      l10n.notificacionTitulo,
      l10n.notificacionCuerpo,
      notificationDetails,
    );
  }

  static int _getColorFromTema(String tema) {
    // Por ejemplo, asigna colores según tema (puedes extender)
    switch (tema) {
      case 'rojo':
        return 0xFFFF0000;
      case 'azul':
        return 0xFF0000FF;
      default:
        return 0xFF2196F3; // azul por defecto
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
