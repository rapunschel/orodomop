import 'package:flutter/widgets.dart';
import 'package:orodomop/models/chrono_cycle.dart';
import 'package:orodomop/models/orodomop.dart';
import 'package:orodomop/models/pomodoro.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:orodomop/providers/settings_provider.dart';
import 'package:orodomop/services/notification_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class TimerProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  late final SettingsProvider _settings;
  int? _X;
  ChronoCycle? _timeManager;

  TimerProvider(this._prefs) {
    int breakTimeRemaining = _prefs.getInt("breakTimeRemaining") ?? 0;
    int focusTime = _prefs.getInt("focusTime") ?? 0;
    String timestamp = _prefs.getString("timestamp") ?? "";
    _X = _prefs.getInt("x");

    _settings = SettingsProvider.getInstance(_prefs);
    _settings.onUsePomodoroCallback = _onTimerSwap;
    _settings.onPomodoroDurationChange = _onPomodoroDurationChange;
    TimerState timerState = TimerState.fromString(
      _prefs.getString("timerState"),
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

    _timeManager = _createTimer(
      focusTime: focusTime,
      breakTimeRemaining: breakTimeRemaining,
      timerState: timerState,
    );
  }

  void _onPomodoroDurationChange(int focusDuration, int breakDuration) {
    if (_timeManager is Pomodoro) {
      (_timeManager as Pomodoro).focusDuration = focusDuration;
      (_timeManager as Pomodoro).breakDuration = breakDuration;

      if (_timeManager!.timerState.isIdle) {
        _timeManager!.resetTimer(); // Update focus/ break time.
      }
      notifyListeners();
    }
  }

  void _onTimerSwap() async {
    await _timeManager!.resetTimer();
    _timeManager = _createTimer();
    notifyListeners();
  }

  ChronoCycle _createTimer({
    int focusTime = 0,
    int breakTimeRemaining = 0,
    TimerState timerState = TimerState.idle,
  }) {
    return _settings.usePomodoro
        ? Pomodoro(
          _settings.focusDuration,
          _settings.breakDuration,
          _settings.focusDuration,
          breakTimeRemaining,
          timerState,
          onStateChanged: notifyListeners,
          clearPrefsCallback: clearPrefs,
          notificationHandler: NotificationHandler(),
        )
        : Orodomop(
          focusTime,
          breakTimeRemaining,
          timerState,
          onStateChanged: notifyListeners,
          clearPrefsCallback: clearPrefs,
          notificationHandler: NotificationHandler(),
        );
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

  void startBreakTimer({int? value}) {
    value == null
        ? _timeManager!.startBreakTimer()
        : _timeManager!.startBreakTimer(value: value);
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
  get usePomodoro => _settings.usePomodoro;
  get rememberX => _settings.rememberX;
  get X => _X;
}
