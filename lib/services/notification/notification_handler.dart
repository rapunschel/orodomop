import 'dart:async';
import 'package:orodomop/services/notification/notification_service.dart';
import 'package:orodomop/services/foreground/service_manager.dart';

class NotificationHandler {
  Future<void> scheduleBreakOverNotification(int time) async {
    NotificationService().schedulePushNotification(
      id: NotificationId.breakOver,
      seconds: time,
      title: "Break is over!",
      body: "Time to focus",
    );
  }

  Future<void> scheduleFocusEndedNotification(int time) async {
    NotificationService().schedulePushNotification(
      id: NotificationId.breakReminder,
      seconds: time,
      title: "Break time!",
      body: "Time for a break...?",
    );
  }

  Future<void> scheduleBreakReminderNotification(int time) async {
    NotificationService().schedulePushNotification(
      id: NotificationId.focusEnd,
      seconds: time,
      title: "Break reminder",
      body: "T",
    );
  }

  Future<void> startFocusForegroundTask(int time) async {
    ServiceManager.startFocusForegroundTask(time);
  }

  Future<void> startBreakForegroundTask(int time) async {
    ServiceManager.startBreakForegroundTask(time);
  }

  Future<void> startForegroundService() async {
    ServiceManager.startService();
  }

  Future<void> stopForegroundTask() async {
    ServiceManager.stopService();
  }

  Future<void> cancelBreakPushNotification() async {
    NotificationService().cancelNotification(NotificationId.breakOver);
  }

  Future<void> cancelBreakReminderNotification() async {
    NotificationService().cancelNotification(NotificationId.breakReminder);
  }

  Future<void> cancelFocusEndedPushNotification() async {
    NotificationService().cancelNotification(NotificationId.focusEnd);
  }
}
