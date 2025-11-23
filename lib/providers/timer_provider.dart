import 'package:flutter/widgets.dart';
import 'package:orodomop/models/chrono_cycle.dart';
import 'package:orodomop/models/orodomop.dart';
import 'package:orodomop/models/pomodoro.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:orodomop/providers/settings_provider.dart';
import 'package:orodomop/services/notification/notification_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class TimerProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  late final SettingsProvider _settings;
  int? _x;
  ChronoCycle? _timeManager;

  TimerProvider(this._prefs) {
    int breakTimeRemaining = _prefs.getInt("breakTimeRemaining") ?? 0;
    int focusTime = _prefs.getInt("focusTime") ?? 0;
    String timestamp = _prefs.getString("timestamp") ?? "";
    _x = _prefs.getInt("X");

    _settings = SettingsProvider.getInstance(_prefs);
    _settings.onUsePomodoroCallback = _onTimerSwap;
    _settings.onPomodoroDurationChange = _onPomodoroDurationChange;
    _settings.onOrodomopSettingsChange = _onOrodomopSettingsChange;
    TimerState timerState = TimerState.fromString(
      _prefs.getString("timerState"),
    );

    if (!timerState.isIdle) {
      if (timerState.isOnFocus) {
        if (_settings.usePomodoro) {
          focusTime -=
              DateTime.now().difference(DateTime.parse(timestamp)).inSeconds;
        } else {
          focusTime +=
              DateTime.now().difference(DateTime.parse(timestamp)).inSeconds;
        }
      } else if (timerState.isOnBreak) {
        breakTimeRemaining -=
            DateTime.now().difference(DateTime.parse(timestamp)).inSeconds;
      }
    }

    debugPrint(
      "Focus: ${focusTime.toString()} | pomo: ${_settings.usePomodoro}",
    );

    _timeManager = _createTimer(
      focusTime: focusTime,
      breakTimeRemaining: breakTimeRemaining,
      timerState: timerState,
    );
  }

  void _onOrodomopSettingsChange(
    bool reminderEnabled,
    int breakReminderSeconds,
  ) {
    if (_timeManager is Orodomop) {
      (_timeManager as Orodomop).breakReminderEnabled = reminderEnabled;
      (_timeManager as Orodomop).breakReminderSeconds = breakReminderSeconds;
    }
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
          breakTimeRemaining == 0
              ? _settings.breakDuration
              : breakTimeRemaining,
          focusTime == 0 ? _settings.focusDuration : focusTime,
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
          _settings.breakReminderEnabled,
          _settings.breakReminderSeconds,
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

    if (_x != null) {
      await _prefs.setInt("X", _x!);
    }
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
    // Pomodoro
    if (value == null) {
      _timeManager!.startBreakTimer();
      return;
    }
    // Orodomop
    _x = value;
    _timeManager!.startBreakTimer(value: value);
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
  get X => _x;
}
