import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  Function? onUsePomodoroCallback;
  Function(int focusDuration, int breakDuration)? onPomodoroDurationChange;

  static SettingsProvider? _instance;
  bool _usePomodoro;
  bool _hideSettingsButton;
  bool _rememberX;
  bool _breakReminderEnabled;
  int _breakReminderSeconds;
  int _focusDuration;
  int _breakDuration;

  SettingsProvider._(
    this._usePomodoro,
    this._prefs,
    this._focusDuration,
    this._breakDuration,
    this._hideSettingsButton,
    this._rememberX,
    this._breakReminderEnabled,
    this._breakReminderSeconds,
  );

  static SettingsProvider getInstance(SharedPreferences prefs) {
    if (_instance != null) return _instance!;
    bool usePomodoro = prefs.getBool("usePomodoro") ?? false;
    // TODO update with proper values after testing
    int focusDuration = prefs.getInt("focusDuration") ?? 6;
    int breakDuration = prefs.getInt("breakDuration") ?? 3;
    int breakReminderSeconds = prefs.getInt("breakReminderSeconds") ?? 10;
    bool breakReminderEnabled = prefs.getBool("breakReminderEnabled") ?? true;
    bool rememberX = prefs.getBool("rememberX") ?? true;
    bool hideSettingsButton = prefs.getBool("hideSettingsButton") ?? false;

    _instance = SettingsProvider._(
      usePomodoro,
      prefs,
      focusDuration,
      breakDuration,
      hideSettingsButton,
      rememberX,
      breakReminderEnabled,
      breakReminderSeconds,
    );
    return _instance!;
  }

  set usePomodoro(bool value) {
    if (_usePomodoro == value) return;

    _usePomodoro = value;
    onUsePomodoroCallback?.call();
    _prefs.setBool("usePomodoro", value);
    notifyListeners();
  }

  set focusDuration(int value) {
    _focusDuration = value;
    _prefs.setInt("focusDuration", value);
    onPomodoroDurationChange!.call(_focusDuration, _breakDuration);
    notifyListeners();
  }

  set breakDuration(int value) {
    _breakDuration = value;
    _prefs.setInt("breakDuration", value);
    onPomodoroDurationChange!.call(_focusDuration, _breakDuration);
    notifyListeners();
  }

  set breakReminderSeconds(int value) {
    _breakReminderSeconds = value;
    _prefs.setInt("breakReminderSeconds", value);
    notifyListeners();
  }

  set hideSettingsButton(bool value) {
    _hideSettingsButton = value;
    _prefs.setBool("hideSettingsButton", value);
    notifyListeners();
  }

  set rememberX(bool value) {
    _rememberX = value;
    _prefs.setBool("rememberX", value);
    notifyListeners();
  }

  set breakReminderEnabled(bool value) {
    _breakReminderEnabled = value;
    _prefs.setBool("breakReminderEnabled", value);
    notifyListeners();
  }

  bool get usePomodoro => _usePomodoro;
  bool get hideSettingsButton => _hideSettingsButton;
  bool get rememberX => _rememberX;
  bool get breakReminderEnabled => _breakReminderEnabled;
  int get breakReminderSeconds => _breakReminderSeconds;
  int get focusDuration => _focusDuration;
  int get breakDuration => _breakDuration;
}
