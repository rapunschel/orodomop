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
  });

  @override
  void startFocusTimer() async {
    timer?.cancel();
    setState(TimerState.onFocus);

    notificationHandler.startForegroundService();
    notificationHandler.scheduleFocusEndedNotification(currFocusTime);

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (--currFocusTime <= 0) {
        notificationHandler.stopForegroundTask();
        setState(TimerState.onBreak);
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

    if (currFocusTime <= 0 && timerState.isOnFocus) {
      breakTime = _breakDuration;
      currFocusTime = 0;
    }
    setState(TimerState.onBreak);
    notificationHandler.scheduleBreakOverNotification(breakTime);
    notificationHandler.startForegroundService();

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
  }

  set breakDuration(int value) {
    _breakDuration = value;
  }
}
