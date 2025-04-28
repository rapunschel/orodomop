import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class TimerModel with ChangeNotifier {
  int _focusTime;
  int _breakTimeRemaining;
  bool _isCounting;
  final SharedPreferences _prefs;
  String _pausedAt; // Keep track when app is sent to background
  Timer? _timer;
  TimerModel._(
    this._focusTime,
    this._breakTimeRemaining,
    this._isCounting,
    this._prefs,
    this._pausedAt,
  );

  // factory constructor to load data.
  static Future<TimerModel> create() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int breakTimeRemaining = prefs.getInt("breakTimeRemaining") ?? 0;
    int focusTime = prefs.getInt("focusTime") ?? 0;
    bool isCounting = prefs.getBool("isCounting") ?? false;
    String pausedAt = prefs.getString("pausedAt") ?? "";

    return TimerModel._(
      focusTime,
      breakTimeRemaining,
      isCounting,
      prefs,
      pausedAt,
    );
  }

  Future<void> saveState() async {
    await _prefs.setInt("breakTimeRemaining", _breakTimeRemaining);
    await _prefs.setInt("focusTime", _focusTime);
    await _prefs.setBool("isCounting", _isCounting);
    await _prefs.setString("pausedAt", _pausedAt);
  }

  void start() {
    _focusTime = 0;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    if (_isCounting) return; // Avoid starting new timers

    _isCounting = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _focusTime++;
      notifyListeners();
    });
  }

  void _countDownTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (--_breakTimeRemaining == 0) {
        _resetTimer();
      }

      notifyListeners();
    });
  }

  void _stopTimer() {
    _isCounting = false;
    _timer?.cancel();
  }

  void _resetTimer() {
    _stopTimer();
    _focusTime = 0;
    _breakTimeRemaining = 0;
    notifyListeners();
  }

  void resume() {
    _startTimer();
    notifyListeners();
  }

  void pause() {
    _stopTimer();
    notifyListeners();
  }

  void relax(int x) {
    _stopTimer(); // Stop the timer in case it's running.
    _breakTimeRemaining = (_focusTime / x).round();
    _countDownTimer(); // Start countdown timer
    notifyListeners();
  }

  void endBreak() {
    _resetTimer();
  }

  static String formatTime(int seconds) {
    int hours;
    int minutes;
    int remSeconds;
    if (seconds < 60) {
      return seconds.toString().padLeft(2, '0');
    } else if (seconds < 3600) {
      minutes = (seconds % 3600) ~/ 60;
      remSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remSeconds.toString().padLeft(2, '0')}';
    }

    hours = seconds ~/ 3600;
    minutes = (seconds % 3600) ~/ 60;
    remSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remSeconds.toString().padLeft(2, '0')}';
  }

  get focusTime => _focusTime;

  get isCounting => _isCounting;
  get breakTimeRemaining => _breakTimeRemaining;
}
