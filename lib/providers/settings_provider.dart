import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  static SettingsProvider? _instance;
  bool _usePomodoro = false;
  SettingsProvider._(this._usePomodoro, this._prefs);

  static Future<SettingsProvider> getInstance() async {
    if (_instance != null) return _instance!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool usePomodoro = prefs.getBool("usePomodoro") ?? false;

    _instance = SettingsProvider._(usePomodoro, prefs);
    return _instance!;
  }

  set usePomodoro(bool value) {
    if (_usePomodoro == value) return;

    _usePomodoro = value;
    _prefs.setBool("usePomodoro", _usePomodoro);
    notifyListeners();
  }

  bool get usePomodoro => _usePomodoro;
}
