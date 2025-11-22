import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  Function? onUsePomodoroCallback;
  Function(int focusDuration, int breakDuration)? onPomodoroDurationChange;

  static SettingsProvider? _instance;
  bool _usePomodoro = false;
  bool _hideSettingsButton;
  int _focusDuration;
  int _breakDuration;

  SettingsProvider._(
    this._usePomodoro,
    this._prefs,
    this._focusDuration,
    this._breakDuration,
    this._hideSettingsButton,
  );

  static SettingsProvider getInstance(SharedPreferences prefs) {
    if (_instance != null) return _instance!;
    bool usePomodoro = prefs.getBool("usePomodoro") ?? false;
    // TODO update with proper values after testing
    int focusDuration = prefs.getInt("focusDuration") ?? 6;
    int breakDuration = prefs.getInt("breakDuration") ?? 3;
    bool hideSettingsButton = prefs.getBool("hideSettingsButton") ?? false;

    _instance = SettingsProvider._(
      usePomodoro,
      prefs,
      focusDuration,
      breakDuration,
      hideSettingsButton,
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
    onPomodoroDurationChange!.call(_focusDuration, _breakDuration);
    notifyListeners();
  }

  set breakDuration(int value) {
    _breakDuration = value;
    _prefs.setInt("breakDuration", _breakDuration);
    onPomodoroDurationChange!.call(_focusDuration, _breakDuration);
    notifyListeners();
  }

  set hideSettingsButton(bool value) {
    _hideSettingsButton = value;
    _prefs.setBool("hideSettingsButton", _hideSettingsButton);
    notifyListeners();
  }

  bool get usePomodoro => _usePomodoro;
  bool get hideSettingsButton => _hideSettingsButton;
  int get focusDuration => _focusDuration;
  int get breakDuration => _breakDuration;
}
