import 'dart:async';
import 'dart:io';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:orodomop/services/foreground_service.dart';
import 'package:permission_handler/permission_handler.dart';

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

      await requestExactAlarmPermission();
    }
  }

  static Future<void> requestExactAlarmPermission() async {
    // Check if the permission is already granted
    PermissionStatus status = await Permission.scheduleExactAlarm.status;

    // If the permission is not granted, request it
    if (!status.isGranted) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  static void initService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notifications',
        channelDescription:
            'Counters', 
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
        serviceTypes: [ForegroundServiceTypes.dataSync],
        serviceId: 256,
        notificationTitle: 'Orodomop is running',
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

  static void startFocusForegroundTask(int time) {
    FlutterForegroundTask.sendDataToTask([TimerHandler.focus, time]);
  }

  static void startBreakForegroundTask(int time) {
    FlutterForegroundTask.sendDataToTask([TimerHandler.relax, time]);
  }
}
