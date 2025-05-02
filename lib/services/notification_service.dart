import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data';

enum NotificationId {
  breakFinished(1);

  final int value;
  const NotificationId(this.value);
}

class NotificationService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Initialize
  Future<void> initNotification() async {
    if (_isInitialized) return;

    // prepare android init settings
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher', // This should be your app icon or a default icon
    );

    // init settings
    const initSettings = InitializationSettings(android: initSettingsAndroid);

    // init the plugin
    await notificationPlugin.initialize(initSettings);
  }

  // Notification details with sound and vibration
  NotificationDetails notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "relax_notifications_channel_id", // Unique ID for the channel
        "Daily Notifications",
        channelDescription: 'Relax end notification',
        importance: Importance.max,
        priority: Priority.high,
        vibrationPattern: Int64List.fromList([
          0,
          500,
          1000,
          500,
        ]), // Vibration pattern
      ),
    );
  }

  // Show Notification
  Future<void> showNotification({
    required NotificationId id,
    required String title,
    required String body,
  }) async {
    return notificationPlugin.show(
      id.value,
      title,
      body,
      notificationDetails(),
    );
  }

  Future<void> cancelNotification(NotificationId id) async {
    await notificationPlugin.cancel(id.value);
  }
}
