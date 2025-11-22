import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  Function? onUsePomodoroCallback;
  static SettingsProvider? _instance;
  bool _usePomodoro = false;
  int _focusDuration;
  int _breakDuration;

  SettingsProvider._(
    this._usePomodoro,
    this._prefs,
    this._focusDuration,
    this._breakDuration,
  );

  static SettingsProvider getInstance(SharedPreferences prefs) {
    if (_instance != null) return _instance!;
    bool usePomodoro = prefs.getBool("usePomodoro") ?? false;
    // TODO update with proper values after testing
    int focusDuration = prefs.getInt("focusDuration") ?? 6;
    int breakDuration = prefs.getInt("breakDuration") ?? 3;

    _instance = SettingsProvider._(
      usePomodoro,
      prefs,
      focusDuration,
      breakDuration,
    );
    return _instance!;
  }

  set usePomodoro(bool value) {
    if (_usePomodoro == value) return;

    _usePomodoro = value;
    onUsePomodoroCallback?.call();
    _prefs.setBool("usePomodoro", _usePomodoro);
    notifyListeners();
  }

  set focusDuration(int value) {
    _focusDuration = value;
    _prefs.setInt("focusDuration", _focusDuration);
    notifyListeners();
  }

  set breakDuration(int value) {
    _breakDuration = value;
    _prefs.setInt("breakDuration", _breakDuration);
    notifyListeners();
  }

  bool get usePomodoro => _usePomodoro;
  int get focusDuration => _focusDuration;
  int get breakDuration => _breakDuration;
}
