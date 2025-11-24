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
  TimerState _timerState;

  ChronoCycle(
    this.currFocusTime,
    this.breakTime,
    this._timerState, {
    required this.onStateChanged,
    required this.clearPrefsCallback,
  });

  void onAppResumed() {
    if (_timerState.isOnFocus) {
      startFocusTimer();
    } else if (_timerState.isOnBreak) {
      startBreakTimer(value: breakTime);
    }
  }

  Future<void> startFocusTimer();

  Future<void> startBreakTimer({int? value});

  Future<void> resume() async {
    if (!_timerState.isPaused) return;

    if (breakTime > 0 && currFocusTime == 0) {
      await startBreakTimer();
    }

    startFocusTimer();
  }

  Future<void> pause() async {
    timer?.cancel();
    await Future.wait(<Future>[
      NotificationHandler.cancelBreakPushNotification(),
      NotificationHandler.cancelBreakReminderNotification(),
      NotificationHandler.cancelFocusEndedPushNotification(),
    ]);
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
