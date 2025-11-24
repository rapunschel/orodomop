import 'dart:async';
import 'package:orodomop/models/chrono_cycle.dart';
import 'package:orodomop/models/timer_state.dart';

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
    required super.notificationHandler,
  }) {
    if (timerState.isIdle) {
      if (!(breakTime > 0)) {
        currFocusTime = _focusDuration;
      }
    }
  }

  @override
  void startFocusTimer() async {
    timer?.cancel();
    setState(TimerState.onFocus);

    notificationHandler.scheduleFocusEndedNotification(currFocusTime);
    await notificationHandler.startForegroundService();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (--currFocusTime <= 0) {
        notificationHandler.stopForegroundTask();
        breakTime = _breakDuration;
        setState(TimerState.idle);
        timer.cancel();
        return;
      }
      notificationHandler.startFocusForegroundTask(currFocusTime);
      onStateChanged();
    });
  }

  @override
  Future<void> resetTimer() async {
    timer?.cancel();
    currFocusTime = _focusDuration;
    breakTime = 0;
    notificationHandler.stopForegroundTask();
    notificationHandler.cancelBreakPushNotification();
    notificationHandler.cancelFocusEndedPushNotification();

    setState(TimerState.idle);
    await clearPrefsCallback();
  }

  @override
  void startBreakTimer({int? value}) async {
    timer?.cancel();

    setState(TimerState.onBreak);
    notificationHandler.scheduleBreakOverNotification(breakTime);
    await notificationHandler.startForegroundService();

    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (breakTime-- <= 0) {
        currFocusTime = _focusDuration;
        setState(TimerState.idle);
        notificationHandler.stopForegroundTask();
        await clearPrefsCallback();
        return;
      }
      onStateChanged.call();
      notificationHandler.startBreakForegroundTask(breakTime);
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
