import 'dart:async';
import 'package:orodomop/services/notification/notification_service.dart';
import 'package:orodomop/services/foreground/service_manager.dart';

class NotificationHandler {
  NotificationHandler._();

  static Future<void> scheduleBreakOverNotification(int time) async {
    NotificationService().schedulePushNotification(
      id: NotificationId.breakOver,
      seconds: time,
      title: "Break is over!",
      body: "Time to focus",
    );
  }

  static Future<void> scheduleFocusEndedNotification(int time) async {
    NotificationService().schedulePushNotification(
      id: NotificationId.focusEnd,
      seconds: time,
      title: "Break time!",
      body: "Time for a break",
    );
  }

  static Future<void> scheduleBreakReminderNotification(int time) async {
    NotificationService().schedulePushNotification(
      id: NotificationId.breakReminder,
      seconds: time,
      title: "Break reminder",
      body: "Take a break?",
    );
  }

  static void startFocusForegroundTask(int time) {
    ServiceManager.startFocusForegroundTask(time);
  }

  static void startBreakForegroundTask(int time) {
    ServiceManager.startBreakForegroundTask(time);
  }

  static Future<void> startForegroundService() async {
    await ServiceManager.startService();
  }

  static Future<void> stopForegroundTask() async {
    await ServiceManager.stopService();
  }

  static Future<void> cancelAllNotifs() async {
    await Future.wait(<Future>[
      cancelBreakPushNotification(),
      cancelBreakReminderNotification(),
      cancelFocusEndedPushNotification(),
      stopForegroundTask(),
    ]);
  }

  static Future<void> cancelBreakPushNotification() async {
    await NotificationService().cancelNotification(NotificationId.breakOver);
  }

  static Future<void> cancelBreakReminderNotification() async {
    await NotificationService().cancelNotification(
      NotificationId.breakReminder,
    );
  }

  static Future<void> cancelFocusEndedPushNotification() async {
    await NotificationService().cancelNotification(NotificationId.focusEnd);
  }
}
