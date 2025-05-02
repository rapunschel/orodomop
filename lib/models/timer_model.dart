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
    debugPrint(timestamp);
    if (timestamp.isEmpty) {
      // empty, avoid formatexception when calling DateTime.parse
    } else if (isCounting) {
      focusTime +=
          DateTime.now().difference(DateTime.parse(timestamp)).inSeconds + 5000;
    } else if (breakTimeRemaining > 0) {
      breakTimeRemaining -=
          DateTime.now().difference(DateTime.parse(timestamp)).inSeconds;
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
    String test = DateTime.now().toString();
    await _prefs.setString("timestamp", test);
    debugPrint("focustime: $focusTime");
    debugPrint("focustime: $test");
  }

  void start() async {
    try {
      // Avoid starting new timers, unless neccessary
      // example: app restart, this ensures timer is started when calling start
      if (_isCounting && _timer != null) {
        return;
      }
      _isCounting = true;
      await saveState(); // Ensure state is saved, in case app is killed
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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      ServiceManager.startService(); // Start the foreground service

      if (--_breakTimeRemaining == 0) {
        _resetTimer();

        // TODO use scheduler for notification.
        NotificationService().showNotification(
          id: 0,
          title: "Orodomop",
          body: "Break finished!",
        );
      }

      // Starts the foreground timer.
      ServiceManager.startRelaxTimer(breakTimeRemaining);
      notifyListeners();
    });
  }

  void _stopTimer() {
    _isCounting = false;
    _timer?.cancel();
  }

  void _resetTimer() async {
    _stopTimer();
    _focusTime = 0;
    _breakTimeRemaining = 0;
    await _prefs.clear(); // Reset sharedpreferences
    notifyListeners();
    ServiceManager.stopService();
  }

  void resume() {
    start();
    notifyListeners();
  }

  void pause() async {
    _stopTimer();
    notifyListeners();
    await saveState(); // save state
  }

  void relax(int x) async {
    _stopTimer(); // Stop the timer in case it's running.
    _breakTimeRemaining = (_focusTime / x).round();
    _focusTime = 0; // reset foucs time.
    await saveState(); // Save state for break
    _countDownTimer(); // Start countdown timer
    notifyListeners();
  }

  void endBreak() {
    _resetTimer();
  }

  get focusTime => _focusTime;
  get isCounting => _isCounting;
  get breakTimeRemaining => _breakTimeRemaining;
}
