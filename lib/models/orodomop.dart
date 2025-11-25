import 'dart:async';
import 'package:orodomop/models/chrono_cycle.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:orodomop/services/notification/notification_handler.dart';

class Orodomop extends ChronoCycle {
  bool _breakReminderEnabled;
  int _breakReminderSeconds;
  Orodomop(
    super.currFocusTime,
    super.breakTime,
    super._timerState,
    this._breakReminderEnabled,
    this._breakReminderSeconds, {
    required super.onStateChanged,
    required super.clearPrefsCallback,
  }) {
    if (timerState.isOnBreak && breakTime <= 0) {
      breakTime = 0;
      setState(TimerState.idle);
    }
  }

  @override
  Future<void> startFocusTimer() async {
    timer?.cancel();
    setState(TimerState.onFocus);

    await Future.wait(<Future>[
      NotificationHandler.cancelBreakPushNotification(),
      NotificationHandler.startForegroundService(),
    ]);

    // Schedule notification on resume.
    if (_breakReminderEnabled && currFocusTime % _breakReminderSeconds != 0) {
      await NotificationHandler.scheduleBreakReminderNotification(
        _breakReminderSeconds - (currFocusTime % _breakReminderSeconds),
      );
    }

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_breakReminderEnabled && currFocusTime % _breakReminderSeconds == 0) {
        NotificationHandler.scheduleBreakReminderNotification(
          _breakReminderSeconds,
        );
      }

      currFocusTime++;
      NotificationHandler.startFocusForegroundTask(currFocusTime);
      onStateChanged();
    });
  }

  @override
  Future<void> resetTimer() async {
    timer?.cancel();
    currFocusTime = 0;
    breakTime = 0;
    await NotificationHandler.cancelAllNotifs();
    setState(TimerState.idle);
    await clearPrefsCallback();
  }

  @override
  Future<void> startBreakTimer({int? value}) async {
    timer?.cancel();

    if (currFocusTime > 0) {
      breakTime = (currFocusTime / value!).round();
      currFocusTime = 0;
    }

    setState(TimerState.onBreak);

    await Future.wait(<Future>[
      NotificationHandler.cancelBreakReminderNotification(),
      NotificationHandler.scheduleBreakOverNotification(breakTime),
      NotificationHandler.startForegroundService(),
    ]);

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (breakTime-- <= 0) {
        timer.cancel();
        setState(TimerState.idle);
        NotificationHandler.stopForegroundTask();
        clearPrefsCallback();
        return;
      }

      onStateChanged.call();
      NotificationHandler.startBreakForegroundTask(breakTime);
    });
  }

  set breakReminderSeconds(int seconds) {
    NotificationHandler.cancelBreakReminderNotification();
    _breakReminderSeconds = seconds;
  }

  set breakReminderEnabled(bool reminderEnabled) {
    NotificationHandler.cancelBreakReminderNotification();
    _breakReminderEnabled = reminderEnabled;
  }

  bool get breakReminderEnabled => _breakReminderEnabled;
  int get breakReminderSeconds => _breakReminderSeconds;
}
