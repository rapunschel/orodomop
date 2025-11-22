import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter/material.dart';
import 'package:orodomop/utils/string_formatter.dart';

// The callback function should always be a top-level or static function.
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(TimerHandler());
}

class TimerHandler extends TaskHandler {
  static const String focus = 'Focusing';
  static const String relax = 'Break';

  void _showFocusNotification(int time) {
    // Update notification content.
    FlutterForegroundTask.updateService(
      notificationTitle: 'Focusing',
      notificationText: StringFormatter.formatTime(time),
    );

    // Send data to main isolate.
    // FlutterForegroundTask.sendDataToMain(time);
  }

  void _showBreakNotification(int time) {
    // Update notification content.
    FlutterForegroundTask.updateService(
      notificationTitle: 'Break',
      notificationText: StringFormatter.formatTime(time),
    );

    // Send data to main isolate.
    //  FlutterForegroundTask.sendDataToMain(time);
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
    List? list = (data is List) ? data : null;
    if (list == null) return;

    // TODO do it better.
    if (list[0] == focus) {
      _showFocusNotification((list[1] is int) ? list[1] : 0);
    } else if (list[0] == relax) {
      _showBreakNotification((list[1] is int) ? list[1] : 0);
    }
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
