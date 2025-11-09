import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:orodomop/services/service_manager.dart';
import 'package:orodomop/services/notification_service.dart';

enum TimerState {
  idle,
  onFocus,
  onBreak,
  paused;

  get isOnFocus => this == onFocus;
  get isIdle => this == idle;
  get isOnBreak => this == onBreak;
  get isPaused => this == paused;

  static TimerState fromString(String? timerState) {
    return TimerState.values.firstWhere(
      (state) => state.name == timerState,
      orElse: () => TimerState.idle,
    );
  }
}

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

    if (timestamp.isEmpty) {
      // empty, avoid formatexception when calling DateTime.parse
    } else if (timerState.isOnFocus) {
      focusTime +=
          DateTime.now().difference(DateTime.parse(timestamp)).inSeconds;
    } else if (timerState.isOnBreak) {
      breakTimeRemaining -=
          DateTime.now().difference(DateTime.parse(timestamp)).inSeconds;

      // Limit desync caused by restarts
      NotificationService().scheduleBreakNotification(
        NotificationId.scheduledNotif,
        breakTimeRemaining,
      );
    }

    TimerModel model = TimerModel._(
      focusTime,
      breakTimeRemaining,
      timerState,
      prefs,
    );

    return model;
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
    try {
      // Avoid starting new timers, unless neccessary
      // example: app restart, this ensures timer is started when calling start
      if (_timerState.isOnFocus && _timer != null) {
        return;
      }
      _timerState = TimerState.onFocus;

      // Cancel in case notif was shown. No longer needed
      NotificationService().cancelNotification(NotificationId.scheduledNotif);
      ServiceManager.startService(); // Start the foreground service

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _focusTime++;
        ServiceManager.startFocusTimer(_focusTime);
        notifyListeners();
      });
    } catch (e) {
      debugPrint("error calling _startTime: $e");
    }
    notifyListeners();
  }

  void onAppRestart() {
    if (_timerState.isOnFocus) {
      startFocusTimer();
    } else if (breakTimeRemaining > 0) {
      _countDownTimer();
    }
  }

  void _countDownTimer() {
    ServiceManager.startService();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (--_breakTimeRemaining <= 0) {
        resetTimer();
        return;
      }

      ServiceManager.startRelaxTimer(breakTimeRemaining);
      notifyListeners();
    });
  }

  void resetTimer() async {
    await clearPrefs();
    _timer?.cancel();
    _focusTime = 0;
    _breakTimeRemaining = 0;
    _timerState = TimerState.idle;
    ServiceManager.stopService();
    notifyListeners();
  }

  void resume() {
    // TODO Implement logic to check which timer to resume
    startFocusTimer();
  }

  void pause() {
    _timer?.cancel();
    _timerState = TimerState.paused;
    ServiceManager.stopService();
    notifyListeners();
  }

  void relax(int x) {
    _timer?.cancel(); // Stop the timer in case it's running.
    _breakTimeRemaining = (_focusTime / x).round();

    NotificationService().scheduleBreakNotification(
      NotificationId.scheduledNotif,
      _breakTimeRemaining,
    );

    _focusTime = 0;
    _timerState = TimerState.onBreak;
    _countDownTimer();
    notifyListeners();
  }

  void endBreak() {
    resetTimer();
    NotificationService().cancelNotification(NotificationId.scheduledNotif);
  }

  get focusTime => _focusTime;
  get isCounting => _timerState.isOnFocus; // TODO update
  get breakTimeRemaining => _breakTimeRemaining;
  get timerState => _timerState;
}
