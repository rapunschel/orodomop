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
  void startFocusTimer() {
    timer?.cancel();
    setState(TimerState.onFocus);
    currFocusTime = 3;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currFocusTime-- <= 0) {
        startBreakTimer(_breakDuration);
        notificationHandler.stopForegroundTask();
        return;
      }
      onStateChanged();
    });
  }

  @override
  Future<void> resetTimer() async {
    timer?.cancel();
    currFocusTime = _breakDuration;
    breakTime = 0;
    setState(TimerState.idle);
    await clearPrefsCallback();
  }

  @override
  void startBreakTimer(int value) {
    timer?.cancel();

    if (currFocusTime <= 0 && timerState.isOnFocus) {
      breakTime = _breakDuration;
      currFocusTime = 0;
    }
    setState(TimerState.onBreak);

    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (breakTime-- <= 0) {
        currFocusTime = _focusDuration;
        setState(TimerState.idle);
        notificationHandler.stopForegroundTask();
        await clearPrefsCallback();
        return;
      }
      onStateChanged.call();
    });
  }
}
