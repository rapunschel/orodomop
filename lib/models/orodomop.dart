import 'dart:async';
import 'package:orodomop/models/chrono_cycle.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:orodomop/services/notification/notification_handler.dart';

class Orodomop extends ChronoCycle {
  bool _breakReminderEnabled;
  int _breakReminderSeconds;
  late int _nextNotificationTime;

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
    _nextNotificationTime =
        _breakReminderSeconds - (currFocusTime % _breakReminderSeconds);
  }

  @override
  Future<void> startFocusTimer() async {
    timer?.cancel();
    setState(TimerState.onFocus);

    await Future.wait(<Future>[
      NotificationHandler.cancelBreakPushNotification(),
      NotificationHandler.startForegroundService(),
    ]);

    // pause / resume
    if (_breakReminderEnabled) {
      if (currFocusTime > 0) {
        await scheduleReminderNotification(
          seconds: _nextNotificationTime - currFocusTime,
        );
      } else {
        await scheduleReminderNotification(seconds: _breakReminderSeconds);
      }
    }

    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_breakReminderEnabled && currFocusTime == _nextNotificationTime) {
        await scheduleReminderNotification(seconds: _breakReminderSeconds);
      }

      currFocusTime++;
      NotificationHandler.startFocusForegroundTask(currFocusTime);
      onStateChanged();
    });
  }

  Future<void> scheduleReminderNotification({int seconds = 0}) async {
    if (seconds <= 0) {
      throw ArgumentError.value(
        seconds,
        'seconds',
        'Cannot schedule reminder in the past',
      );
    }

    _nextNotificationTime = currFocusTime + seconds;
    await NotificationHandler.scheduleBreakReminderNotification(seconds);
  }

  @override
  Future<void> resetTimer() async {
    timer?.cancel();
    currFocusTime = 0;
    breakTime = 0;
    _nextNotificationTime = currFocusTime;

    await Future.wait(<Future>[
      NotificationHandler.cancelAllNotifs(),
      clearPrefsCallback(),
    ]);

    setState(TimerState.idle);
  }

  @override
  Future<void> startBreakTimer({int? value}) async {
    timer?.cancel();

    if (currFocusTime > 0) {
      breakTime = (currFocusTime / value!).round();
      currFocusTime = 0;
      _nextNotificationTime = currFocusTime;
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

  Future<void> setBreakReminderSeconds(int seconds) async {
    if (_breakReminderSeconds == seconds) return;

    await NotificationHandler.cancelBreakReminderNotification();
    _breakReminderSeconds = seconds;

    if (_breakReminderEnabled && timerState.isOnFocus) {
      await scheduleReminderNotification(seconds: _breakReminderSeconds);
    }
  }

  Future<void> setBreakReminderEnabled(bool reminderEnabled) async {
    if (_breakReminderEnabled == reminderEnabled) return;
    _breakReminderEnabled = reminderEnabled;

    if (!_breakReminderEnabled) {
      await NotificationHandler.cancelBreakReminderNotification();
    }

    if (_breakReminderEnabled && timerState.isOnFocus) {
      await scheduleReminderNotification(seconds: _breakReminderSeconds);
      return;
    }
  }

  bool get breakReminderEnabled => _breakReminderEnabled;
  int get breakReminderSeconds => _breakReminderSeconds;
}
