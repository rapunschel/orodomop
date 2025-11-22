import 'dart:async';
import 'package:orodomop/models/chrono_cycle.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:flutter/foundation.dart';

class Orodomop extends ChronoCycle {
  bool breakReminderEnabled;
  int breakReminderSeconds;
  Orodomop(
    super.currFocusTime,
    super.breakTime,
    super._timerState,
    this.breakReminderEnabled,
    this.breakReminderSeconds, {
    required super.onStateChanged,
    required super.clearPrefsCallback,
    required super.notificationHandler,
  });

  @override
  void startFocusTimer() async {
    timer?.cancel();
    setState(TimerState.onFocus);
    notificationHandler.cancelBreakPushNotification();
    await notificationHandler.startForegroundService();

    await notificationHandler.scheduleBreakReminderNotification(10);

    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (breakReminderEnabled && currFocusTime % breakReminderSeconds == 0) {
        await notificationHandler.scheduleBreakReminderNotification(
          breakReminderSeconds,
        );
      }
      currFocusTime++;

      notificationHandler.startFocusForegroundTask(currFocusTime);

      onStateChanged();
    });
  }

  @override
  Future<void> resetTimer() async {
    timer?.cancel();
    currFocusTime = 0;
    breakTime = 0;
    notificationHandler.stopForegroundTask();
    notificationHandler.cancelBreakPushNotification();
    notificationHandler.cancelBreakReminderNotification();
    setState(TimerState.idle);
    await clearPrefsCallback();
  }

  @override
  void startBreakTimer({int? value}) async {
    timer?.cancel();

    if (currFocusTime > 0) {
      breakTime = (currFocusTime / value!).round();
      currFocusTime = 0;
    }

    setState(TimerState.onBreak);
    notificationHandler.cancelBreakReminderNotification();
    notificationHandler.scheduleBreakOverNotification(breakTime);
    await notificationHandler.startForegroundService();

    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (breakTime-- <= 0) {
        setState(TimerState.idle);
        notificationHandler.stopForegroundTask();
        await clearPrefsCallback();
        return;
      }

      onStateChanged.call();
      notificationHandler.startBreakForegroundTask(breakTime);
    });
  }
}
