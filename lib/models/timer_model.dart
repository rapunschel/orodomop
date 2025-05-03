import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:orodomop/services/service_manager.dart';
import 'package:orodomop/services/notification_service.dart';

class TimerModel with ChangeNotifier {
  int _focusTime;
  int _breakTimeRemaining;
  bool _isCounting;
  final SharedPreferences _prefs;
  Timer? _timer;
  TimerModel._(
    this._focusTime,
    this._breakTimeRemaining,
    this._isCounting,
    this._prefs,
  );

  // factory constructor to load data.
  static Future<TimerModel> create() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int breakTimeRemaining = prefs.getInt("breakTimeRemaining") ?? 0;
    int focusTime = prefs.getInt("focusTime") ?? 0;
    bool isCounting = prefs.getBool("isCounting") ?? false;
    String timestamp = prefs.getString("timestamp") ?? "";

    if (timestamp.isEmpty) {
      // empty, avoid formatexception when calling DateTime.parse
    } else if (isCounting) {
      focusTime +=
          DateTime.now().difference(DateTime.parse(timestamp)).inSeconds;
    } else if (breakTimeRemaining > 0) {
      breakTimeRemaining -=
          DateTime.now().difference(DateTime.parse(timestamp)).inSeconds;

      // Limit desync caused by restarts
      NotificationService().scheduleBreakNotification(
        NotificationId.scheduledNotif,
        breakTimeRemaining,
      );
    }

    TimerModel model = TimerModel._(
      focusTime,
      breakTimeRemaining,
      isCounting,
      prefs,
    );

    return model;
  }

  Future<void> saveState() async {
    await _prefs.setInt("breakTimeRemaining", _breakTimeRemaining);
    await _prefs.setInt("focusTime", _focusTime);
    await _prefs.setBool("isCounting", _isCounting);
    await _prefs.setString("timestamp", DateTime.now().toString());
  }

  void start() {
    try {
      // Avoid starting new timers, unless neccessary
      // example: app restart, this ensures timer is started when calling start
      if (_isCounting && _timer != null) {
        return;
      }

      // Cancel in case notif was shown. No longer needed
      NotificationService().cancelNotification(NotificationId.scheduledNotif);
      _isCounting = true;
      ServiceManager.startService(); // Start the foreground service

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _focusTime++;
        ServiceManager.startFocusTimer(_focusTime);
        notifyListeners();
      });
    } catch (e) {
      debugPrint("error calling _startTime: $e");
    }
    notifyListeners();
  }

  void onAppRestart() {
    if (isCounting) {
      start();
    } else if (breakTimeRemaining > 0) {
      _countDownTimer();
    }
  }

  void _countDownTimer() {
    ServiceManager.startService();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (--_breakTimeRemaining <= 0) {
        _resetTimer();
        return;
      }

      ServiceManager.startRelaxTimer(breakTimeRemaining);
      notifyListeners();
    });
  }

  void _stopTimer() {
    _isCounting = false;
    _timer?.cancel();
  }

  void _resetTimer() async {
    await _prefs.clear(); // Reset sharedpreferences
    _stopTimer();
    _focusTime = 0;
    _breakTimeRemaining = 0;
    ServiceManager.stopService();
    notifyListeners();
  }

  void resume() {
    start();
    notifyListeners();
  }

  void pause() async {
    _stopTimer();
    ServiceManager.stopService();
    notifyListeners();
  }

  void relax(int x) {
    _stopTimer(); // Stop the timer in case it's running.
    _breakTimeRemaining = (_focusTime / x).round();

    NotificationService().scheduleBreakNotification(
      NotificationId.scheduledNotif,
      _breakTimeRemaining,
    );

    _focusTime = 0;
    _countDownTimer();
    notifyListeners();
  }

  void endBreak() {
    _resetTimer();
    NotificationService().cancelNotification(NotificationId.scheduledNotif);
  }

  get focusTime => _focusTime;
  get isCounting => _isCounting;
  get breakTimeRemaining => _breakTimeRemaining;
}
