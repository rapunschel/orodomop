import 'package:flutter/widgets.dart';
import 'package:orodomop/models/chrono_cycle.dart';
import 'package:orodomop/models/orodomop.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:orodomop/services/notification_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class TimerProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  ChronoCycle? _timeManager;

  TimerProvider(this._prefs) {
    int breakTimeRemaining = _prefs.getInt("breakTimeRemaining") ?? 0;
    int focusTime = _prefs.getInt("focusTime") ?? 0;
    String timestamp = _prefs.getString("timestamp") ?? "";
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
    _timeManager = Orodomop(
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
