import 'dart:async';
import 'package:orodomop/models/chrono_cycle.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:orodomop/services/notification/notification_handler.dart';

class Pomodoro extends ChronoCycle {
  int _focusDuration;
  int _breakDuration;
  Pomodoro(
    this._focusDuration,
    this._breakDuration,
    super.currFocusTime,
    super.breakTime,
    super._timerState, {
    required super.onStateChanged,
    required super.clearPrefsCallback,
  }) {
    if (timerState.isIdle) {
      if (!(breakTime > 0)) {
        currFocusTime = _focusDuration;
      }
    }
  }

  @override
  Future<void> startFocusTimer() async {
    timer?.cancel();
    setState(TimerState.onFocus);
    await Future.wait(<Future>[
      NotificationHandler.scheduleFocusEndedNotification(currFocusTime),
      NotificationHandler.startForegroundService(),
    ]);

    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (--currFocusTime <= 0) {
        timer.cancel();
        NotificationHandler.stopForegroundTask();
        breakTime = _breakDuration;
        setState(TimerState.idle);
        return;
      }
      NotificationHandler.startFocusForegroundTask(currFocusTime);
      onStateChanged();
    });
  }

  @override
  Future<void> resetTimer() async {
    timer?.cancel();
    currFocusTime = _focusDuration;
    breakTime = 0;

    await NotificationHandler.cancelAllNotifs();

    setState(TimerState.idle);
    await clearPrefsCallback();
  }

  @override
  Future<void> startBreakTimer({int? value}) async {
    timer?.cancel();

    setState(TimerState.onBreak);

    await Future.wait(<Future>[
      NotificationHandler.scheduleBreakOverNotification(breakTime),
      NotificationHandler.startForegroundService(),
    ]);

    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (breakTime-- <= 0) {
        timer.cancel();
        currFocusTime = _focusDuration;
        setState(TimerState.idle);
        NotificationHandler.stopForegroundTask();
        await clearPrefsCallback();
        return;
      }
      onStateChanged.call();
      NotificationHandler.startBreakForegroundTask(breakTime);
    });
  }

  set focusDuration(int value) {
    _focusDuration = value;

    if (timerState.isIdle) {
      currFocusTime = value;
      onStateChanged();
    }
  }

  set breakDuration(int value) {
    _breakDuration = value;

    if (timerState.isIdle && focusTime <= 0) {
      breakTime = value;
      onStateChanged();
    }
  }
}
