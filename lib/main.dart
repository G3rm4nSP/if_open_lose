import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:if_open_lose/src/notifications/notification_list_charge.dart';
import 'src/app.dart';
import 'src/notifications/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 Mensaje recibido en segundo plano: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // REGISTRAR HANDLER DE MENSAJES EN SEGUNDO PLANO
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //temporal
  //await CargarNotificaciones.insertarMensajes();

  // Inicializar y pedir permisos de notificación
  await NotificationService.init();
  await NotificationService.requestPermissions();

  runApp(const MyApp());
}
