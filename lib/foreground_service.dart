import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter/material.dart';

// The callback function should always be a top-level or static function.
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(TimerHandler());
}

class TimerHandler extends TaskHandler {
  //static const String updateTime = 'updateTime';

  void _updateTime(int time) {
    // Update notification content.
    FlutterForegroundTask.updateService(
      notificationTitle: 'Focusing',
      notificationText: 'count: $time',
    );

    // Send data to main isolate.
    FlutterForegroundTask.sendDataToMain(time);
  }

  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    debugPrint('onStart(starter: ${starter.name})');
  }

  // Called based on the eventAction set in ForegroundTaskOptions.
  @override
  void onRepeatEvent(DateTime timestamp) {
    // empty for now
  }

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    debugPrint('onDestroy(isTimeout: $isTimeout)');
  }

  // Called when data is sent using `FlutterForegroundTask.sendDataToTask`.
  @override
  void onReceiveData(Object data) {
    _updateTime((data is int) ? data : 0);
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    debugPrint('onNotificationButtonPressed: $id');
  }

  // Called when the notification itself is pressed.
  @override
  void onNotificationPressed() {
    debugPrint('onNotificationPressed');
  }

  // Called when the notification itself is dismissed.
  @override
  void onNotificationDismissed() {
    debugPrint('onNotificationDismissed');
  }
}
