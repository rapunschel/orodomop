import 'dart:async';
import 'package:orodomop/models/chrono_cycle.dart';
import 'package:orodomop/models/timer_state.dart';

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
    required super.notificationHandler,
  });

  @override
  void startFocusTimer() async {
    timer?.cancel();
    setState(TimerState.onFocus);
    notificationHandler.cancelBreakPushNotification();
    await notificationHandler.startForegroundService();

    // Schedule notification on resume.
    if (_breakReminderEnabled && currFocusTime % _breakReminderSeconds != 0) {
      notificationHandler.scheduleBreakReminderNotification(
        _breakReminderSeconds - (currFocusTime % _breakReminderSeconds),
      );
    }

    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_breakReminderEnabled && currFocusTime % _breakReminderSeconds == 0) {
        await notificationHandler.scheduleBreakReminderNotification(
          _breakReminderSeconds,
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

  set breakReminderSeconds(int seconds) {
    notificationHandler.cancelBreakReminderNotification();
    _breakReminderSeconds = seconds;
  }

  set breakReminderEnabled(bool reminderEnabled) {
    notificationHandler.cancelBreakReminderNotification();
    _breakReminderEnabled = reminderEnabled;
  }

  bool get breakReminderEnabled => _breakReminderEnabled;
  int get breakReminderSeconds => _breakReminderSeconds;
}
