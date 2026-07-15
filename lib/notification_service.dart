import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static bool _initialized = false;
  static final FlutterLocalNotificationsPlugin _androidNotifications =
      FlutterLocalNotificationsPlugin();

  /// Inicializa el servicio únicamente si está en un entorno Android
  static Future<void> initialize() async {
    if (kIsWeb) return;

    if (Platform.isAndroid) {
      try {
        // Configuramos el icono de notificación predeterminado de Android.
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');

        const InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
        );

        await _androidNotifications.initialize(settings: initializationSettings);
        _initialized = true;
        debugPrint('NotificationService initialized for Android');

        // Solicitar el permiso inmediatamente en Android 13+
        await requestAndroidPermission();
      } catch (error, stackTrace) {
        _initialized = false;
        debugPrint('NotificationService Android initialization failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }

  /// Solicita permisos de notificación en tiempo de ejecución (crucial para Android 13+)
  static Future<bool> requestAndroidPermission() async {
    if (Platform.isAndroid) {
      try {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _androidNotifications.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        
        final bool? granted = await androidImplementation?.requestNotificationsPermission();
        return granted ?? false;
      } catch (error) {
        debugPrint('Failed to request Android notification permissions: $error');
        return false;
      }
    }
    return false;
  }

  /// Dispara una notificación local en Android
  static Future<void> showNotification(String title, String body) async {
    if (kIsWeb) return;

    if (!_initialized) {
      await initialize();
    }

    if (Platform.isAndroid) {
      try {
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'alazar_channel_id',
          'Alazar Notifications',
          channelDescription: 'Canal de notificaciones para el reproductor Alazar',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

        const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
        );

        await _androidNotifications.show(
          id: 0,
          title: title,
          body: body,
          notificationDetails: platformChannelSpecifics,
        );
      } catch (error, stackTrace) {
        debugPrint('NotificationService showNotification failed on Android: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }
}