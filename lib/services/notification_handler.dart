import 'dart:async';
import 'package:orodomop/services/notification_service.dart';
import 'package:orodomop/services/service_manager.dart';

class NotificationHandler {
  Future<void> scheduleBreakOverNotification(int time) async {
    NotificationService().scheduleBreakNotification(
      NotificationId.breakOver,
      time,
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
}
