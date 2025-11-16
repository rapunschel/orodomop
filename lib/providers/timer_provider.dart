import 'package:flutter/widgets.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:orodomop/services/service_manager.dart';
import 'package:orodomop/services/notification_service.dart';

class TimerProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  ChronoCycle? _timeManager;
  TimerProvider._(this._prefs);

  static Future<TimerProvider> create() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int breakTimeRemaining = prefs.getInt("breakTimeRemaining") ?? 0;
    int focusTime = prefs.getInt("focusTime") ?? 0;
    String timestamp = prefs.getString("timestamp") ?? "";
    TimerState timerState = TimerState.fromString(
      prefs.getString("timerState"),
    );

    if (!timerState.isIdle) {
      if (timerState.isOnFocus) {
        focusTime +=
            DateTime.now().difference(DateTime.parse(timestamp)).inSeconds;
      } else if (timerState.isOnBreak) {
        breakTimeRemaining -=
            DateTime.now().difference(DateTime.parse(timestamp)).inSeconds;
      }
    }

    TimerProvider model = TimerProvider._(prefs);

    model.timeManager = Orodomop(
      focusTime,
      breakTimeRemaining,
      timerState,
      onStateChanged: model.notifyListeners,
      clearPrefsCallback: model.clearPrefs,
    );

    return model;
  }

  Future<void> saveState() async {
    await _prefs.setInt("breakTimeRemaining", _timeManager!.breakTimeRemaining);
    await _prefs.setInt("focusTime", _timeManager!.focusTime);
    await _prefs.setString("timestamp", DateTime.now().toString());
    await _prefs.setString("timerState", _timeManager!.timerState.name);
  }

  Future<void> clearPrefs() async {
    await _prefs.remove("breakTimeRemaining");
    await _prefs.remove("focusTime");
    await _prefs.remove("timestamp");
    await _prefs.remove("timerState");
  }

  void onAppResumed() {
    _timeManager!.onAppResumed();
  }

  void startFocusTimer() {
    _timeManager!.startFocusTimer();
  }

  void startBreakTimer(int value) {
    _timeManager!.startBreakTimer(value);
  }

  void resetTimer() {
    _timeManager!.resetTimer();
  }

  void resume() {
    _timeManager!.resume();
  }

  void pause() {
    _timeManager!.pause();
  }

  set timeManager(ChronoCycle timer) => _timeManager = timer;

  get focusTime => _timeManager!.focusTime;
  get breakTimeRemaining => _timeManager!.breakTimeRemaining;
  get timerState => _timeManager!.timerState;
}

class Orodomop extends ChronoCycle {
  Orodomop(
    super._focusTime,
    super._breakTimeRemaining,
    super._timerState, {
    required super.onStateChanged,
    required super.clearPrefsCallback,
  });

  @override
  void startFocusTimer() {
    _timer?.cancel();
    _setState(TimerState.onFocus);

    Future(() {
      NotificationService().cancelNotification(NotificationId.breakOver);
      ServiceManager.startService();
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _focusTime++;
      ServiceManager.startFocusForegroundTask(_focusTime);
      _onStateChanged();
    });
  }

  @override
  void startBreakTimer(int value) {
    _timer?.cancel();

    if (_focusTime > 0) {
      _breakTimeRemaining = (_focusTime / value).round();
      _focusTime = 0;
    }

    _setState(TimerState.onBreak);

    Future(() {
      NotificationService().scheduleBreakNotification(
        NotificationId.breakOver,
        _breakTimeRemaining,
      );
      ServiceManager.startService();
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_breakTimeRemaining-- <= 0) {
        _setState(TimerState.idle);
        ServiceManager.stopService();
        await _clearPrefsCallback();
        return;
      }
      _onStateChanged.call();
      ServiceManager.startBreakForegroundTask(_breakTimeRemaining);
    });
  }
}

abstract class ChronoCycle {
  int _focusTime;
  int _breakTimeRemaining;
  Timer? _timer;
  final Function _onStateChanged;
  final Future<void> Function() _clearPrefsCallback;
  TimerState _timerState;

  ChronoCycle(
    this._focusTime,
    this._breakTimeRemaining,
    this._timerState, {
    required Function onStateChanged,
    required Future<void> Function() clearPrefsCallback,
  }) : _clearPrefsCallback = clearPrefsCallback,
       _onStateChanged = onStateChanged;

  void onAppResumed() {
    if (_timerState.isOnFocus) {
      startFocusTimer();
    } else if (_timerState.isOnBreak) {
      startBreakTimer(_breakTimeRemaining);
    }
  }

  void startFocusTimer();

  void startBreakTimer(int value);

  void resume() {
    if (!_timerState.isPaused) return;

    if (_breakTimeRemaining > 0 && _focusTime == 0) {
      return startBreakTimer(_breakTimeRemaining);
    }

    startFocusTimer();
  }

  void pause() {
    _timer?.cancel();
    ServiceManager.stopService();
    NotificationService().cancelNotification(NotificationId.breakOver);
    _setState(TimerState.paused);
  }

  void resetTimer() async {
    await _clearPrefsCallback();
    _timer?.cancel();
    _focusTime = 0;
    _breakTimeRemaining = 0;

    Future(() {
      NotificationService().cancelNotification(NotificationId.breakOver);
      ServiceManager.stopService();
    });

    _setState(TimerState.idle);
  }

  void _setState(TimerState state, {bool notify = true}) {
    _timerState = state;
    if (notify) _onStateChanged.call();
  }

  get focusTime => _focusTime;
  get breakTimeRemaining => _breakTimeRemaining;
  TimerState get timerState => _timerState;
}
