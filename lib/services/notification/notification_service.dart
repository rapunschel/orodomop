import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/widgets.dart';
import 'dart:async';

enum NotificationId {
  focusEnd(1),
  breakOver(1);

  final int value;
  const NotificationId(this.value);
}

class NotificationService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher', // app icon or a default icon
    );

    const initSettings = InitializationSettings(android: initSettingsAndroid);
    await notificationPlugin.initialize(initSettings);
  }

  void schedulePushNotification({
    required NotificationId id,
    required int seconds,
    required String title,
    required String body,
  }) {
    try {
      final scheduledTime = tz.TZDateTime.now(
        tz.local,
      ).add(Duration(seconds: seconds));

      notificationPlugin.zonedSchedule(
        id.value, // Notification ID
        title,
        body,
        scheduledTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            "break_notifications_channel_id", // Unique ID for the channel
            "Push Notifications",
            channelDescription: 'Push notification.',
            importance: Importance.max,
            priority: Priority.high,
            vibrationPattern: Int64List.fromList([0, 500, 1000, 500]),
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint("Notification scheduled successfully.");
    } catch (e) {
      debugPrint("Error scheduling notification: $e");
    }
  }

  Future<void> cancelNotification(NotificationId id) async {
    await notificationPlugin.cancel(id.value);
  }
}
