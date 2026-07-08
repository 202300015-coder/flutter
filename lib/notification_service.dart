import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Configuración para Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración general
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    // Inicializar el plugin
    await notificationsPlugin.initialize(settings);

    // Crear el canal de notificaciones (Android 8+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'alazar_channel', // ID del canal
      'Alazar Notifications', // Nombre visible
      description: 'Canal de notificaciones de la aplicación Alazar',
      importance: Importance.high,
    );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Solicitar permiso en Android 13+
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showNotification(
    String title,
    String body,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'alazar_channel',
      'Alazar Notifications',
      channelDescription: 'Canal de notificaciones de la aplicación Alazar',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}