import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:orodomop/services/notification/notification_handler.dart';

abstract class ChronoCycle {
  @protected
  int currFocusTime;
  @protected
  int breakTime;
  @protected
  Timer? timer;
  @protected
  final Function onStateChanged;
  @protected
  final Future<void> Function() clearPrefsCallback;
  @protected
  final NotificationHandler notificationHandler;
  TimerState _timerState;

  ChronoCycle(
    this.currFocusTime,
    this.breakTime,
    this._timerState, {
    required this.onStateChanged,
    required this.clearPrefsCallback,
    required this.notificationHandler,
  });

  void onAppResumed() {
    if (_timerState.isOnFocus) {
      startFocusTimer();
    } else if (_timerState.isOnBreak) {
      startBreakTimer(value: breakTime);
    }
  }

  void startFocusTimer();

  void startBreakTimer({int? value});

  void resume() {
    if (!_timerState.isPaused) return;

    if (breakTime > 0 && currFocusTime == 0) {
      return startBreakTimer();
    }

    startFocusTimer();
  }

  void pause() {
    timer?.cancel();
    notificationHandler.stopForegroundTask();
    notificationHandler.cancelBreakPushNotification();
    notificationHandler.cancelFocusEndedPushNotification();
    setState(TimerState.paused);
  }

  Future<void> resetTimer();

  @protected
  void setState(TimerState state, {bool notify = true}) {
    _timerState = state;
    if (notify) onStateChanged.call();
  }

  get focusTime => currFocusTime;
  get breakTimeRemaining => breakTime;
  TimerState get timerState => _timerState;
}
