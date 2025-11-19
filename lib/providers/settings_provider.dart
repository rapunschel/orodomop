import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  static SettingsProvider? _instance;

  SettingsProvider._(this._prefs);

  static Future<SettingsProvider> getInstance() async {
    if (_instance != null) return _instance!;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _instance = SettingsProvider._(prefs);
    return _instance!;
  }
}
