import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ThemeModel with ChangeNotifier {
  bool _isLightTheme;
  final SharedPreferences _prefs;

  ThemeModel._(this._isLightTheme, this._prefs);

  static Future<ThemeModel> create() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLightTheme = prefs.getBool("isLightTheme") ?? true;
    return ThemeModel._(isLightTheme, prefs);
  }

  Future<void> saveState() async {
    await _prefs.setBool("isLightTheme", _isLightTheme);
  }

  void toggleTheme() {
    _isLightTheme = !_isLightTheme;
    saveState();
  }

  get isLightTheme => _isLightTheme;
}
