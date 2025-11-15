import 'package:flutter/widgets.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:orodomop/services/service_manager.dart';
import 'package:orodomop/services/notification_service.dart';

class TimerModel with ChangeNotifier {
  final SharedPreferences _prefs;
  int _focusTime;
  int _breakTimeRemaining;
  Timer? _timer;
  TimerState _timerState;

  TimerModel._(
    this._focusTime,
    this._breakTimeRemaining,
    this._timerState,
    this._prefs,
  );

  static Future<TimerModel> create() async {
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

    TimerModel model = TimerModel._(
      focusTime,
      breakTimeRemaining,
      timerState,
      prefs,
    );

    return model;
  }

  void onAppResumed() {
    if (_timerState.isOnFocus) {
      startFocusTimer();
    } else if (_timerState.isOnBreak) {
      startBreakTimer(_breakTimeRemaining);
    }
  }

  Future<void> saveState() async {
    await _prefs.setInt("breakTimeRemaining", _breakTimeRemaining);
    await _prefs.setInt("focusTime", _focusTime);
    await _prefs.setString("timestamp", DateTime.now().toString());
    await _prefs.setString("timerState", _timerState.name);
  }

  Future<void> clearPrefs() async {
    await _prefs.remove("breakTimeRemaining");
    await _prefs.remove("focusTime");
    await _prefs.remove("timestamp");
    await _prefs.remove("timerState");
  }

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
      notifyListeners();
    });
  }

  void _finishBreak() async {
    _timerState = TimerState.idle;
    notifyListeners();
    ServiceManager.stopService();
    await clearPrefs();
  }

  void resetTimer() async {
    await clearPrefs();
    _timer?.cancel();
    _focusTime = 0;
    _breakTimeRemaining = 0;

    Future(() {
      NotificationService().cancelNotification(NotificationId.breakOver);
      ServiceManager.stopService();
    });

    _setState(TimerState.idle);
  }

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

  void startBreakTimer(int x) {
    _timer?.cancel();

    if (_focusTime > 0) {
      _breakTimeRemaining = (_focusTime / x).round();
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

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_breakTimeRemaining-- <= 0) {
        _finishBreak();
        return;
      }
      notifyListeners();
      ServiceManager.startBreakForegroundTask(_breakTimeRemaining);
    });
  }

  void _setState(TimerState state, {bool notify = true}) {
    _timerState = state;
    if (notify) notifyListeners();
  }

  get focusTime => _focusTime;
  get breakTimeRemaining => _breakTimeRemaining;
  get timerState => _timerState;
}
