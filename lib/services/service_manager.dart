import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:orodomop/services/foreground_service.dart';

class ServiceManager {
  // SETUP
  static Future<void> requestPermissions() async {
    // Android 13+, you need to allow notification permission to display foreground service notification.
    //
    // iOS: If you need notification, ask for permission.
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      // Android 12+, there are restrictions on starting a foreground service.
      //
      // To restart the service on device reboot or unexpected problem, you need to allow below permission.
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }
    }
  }

  static void initService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(1000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  // START, STOP
  static Future<ServiceRequestResult> startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        // You can manually specify the foregroundServiceType for the service
        // to be started, as shown in the comment below.
        // serviceTypes: [
        //   ForegroundServiceTypes.dataSync,
        //   ForegroundServiceTypes.remoteMessaging,
        // ],
        serviceId: 256,
        notificationTitle: 'Orodomp is running',
        notificationText: 'Tap to return to the app',
        notificationIcon: null,
        /*notificationButtons: [
          const NotificationButton(id: 'btn_hello', text: 'hello'),
        ],*/
        notificationInitialRoute: '/',
        callback: startCallback,
      );
    }
  }

  static Future<ServiceRequestResult> stopService() {
    return FlutterForegroundTask.stopService();
  }

  // Receiving
  static void onReceiveTaskData(Object data) {
    //debugPrint('onReceiveTaskData: $data');
  }

  // Sending

  static void startFocusTimer(int time) {
    FlutterForegroundTask.sendDataToTask([TimerHandler.focus, time]);
  }

  static void startRelaxTimer(int time) {
    FlutterForegroundTask.sendDataToTask([TimerHandler.relax, time]);
  }
}
