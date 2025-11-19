import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ThemeProvider with ChangeNotifier {
  late bool _isLightTheme;
  final SharedPreferences _prefs;

  ThemeProvider(this._prefs) {
    _isLightTheme = _prefs.getBool("isLightTheme") ?? false;
  }

  Future<void> saveState() async {
    await _prefs.setBool("isLightTheme", _isLightTheme);
  }

  void toggleTheme() {
    _isLightTheme = !_isLightTheme;
    saveState();
    notifyListeners();
  }

  get isLightTheme => _isLightTheme;
}
