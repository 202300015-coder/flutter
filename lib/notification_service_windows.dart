import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:local_notifier/local_notifier.dart';

class NotificationService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (!kIsWeb && Platform.isWindows) {
      try {
        await localNotifier.setup(
          appName: 'Alazar',
          shortcutPolicy: ShortcutPolicy.requireCreate,
        );
        _initialized = true;
        debugPrint('NotificationService initialized for Windows');
      } catch (error, stackTrace) {
        _initialized = false;
        debugPrint('NotificationService initialization failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }

  static Future<void> showNotification(String title, String body) async {
    if (!kIsWeb && Platform.isWindows) {
      if (!_initialized) {
        await initialize();
      }

      try {
        final LocalNotification notification = LocalNotification(
          title: title,
          body: body,
          silent: false,
        );

        await notification.show();
      } catch (error, stackTrace) {
        debugPrint('NotificationService showNotification failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }
}