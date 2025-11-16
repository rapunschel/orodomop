import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ThemeProvider with ChangeNotifier {
  bool _isLightTheme;
  final SharedPreferences _prefs;

  ThemeProvider._(this._isLightTheme, this._prefs);

  static Future<ThemeProvider> create() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLightTheme = prefs.getBool("isLightTheme") ?? false;
    return ThemeProvider._(isLightTheme, prefs);
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
