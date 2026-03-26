import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/timer_model.dart';

enum TimerStatus { idle, running, paused, completed }

class TimerProvider extends ChangeNotifier {
  Timer? _timer;

  // Wheel-picked values
  int _hours = 0;
  int _minutes = 5;
  int _seconds = 0;

  // Remaining time (for pause/resume)
  int _remainingSeconds = 0;

  TimerStatus _status = TimerStatus.idle;

  // Label & sound
  String _label = 'Timer';
  String _sound = 'Radar';

  // Recent timers
  final List<TimerModel> _recents = [
    TimerModel(duration: const Duration(minutes: 5), label: 'Focus', sound: 'Radar'),
    TimerModel(duration: const Duration(minutes: 10), label: 'Break', sound: 'Radar'),
    TimerModel(duration: const Duration(minutes: 1), label: 'Quick', sound: 'Radar'),
  ];

  // Getters
  int get hours => _hours;
  int get minutes => _minutes;
  int get seconds => _seconds;
  TimerStatus get status => _status;
  String get label => _label;
  String get sound => _sound;
  List<TimerModel> get recents => List.unmodifiable(_recents);

  Duration get wheelDuration => Duration(
    hours: _hours,
    minutes: _minutes,
    seconds: _seconds,
  );

  String get displayTime {
    if (_hours > 0) {
      return '${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}';
    }
    if (_seconds == 0) {
      return '$_minutes:00';
    }
    return '$_minutes:${_seconds.toString().padLeft(2, '0')}';
  }

  bool get isRunning => _status == TimerStatus.running;
  bool get isIdle => _status == TimerStatus.idle;
  bool get isPaused => _status == TimerStatus.paused;

  // Wheel setters (called while idle)
  void setHours(int h) {
    _hours = h;
    notifyListeners();
  }

  void setMinutes(int m) {
    _minutes = m;
    notifyListeners();
  }

  void setSeconds(int s) {
    _seconds = s;
    notifyListeners();
  }

  void setWheelValues(int h, int m, int s) {
    _hours = h;
    _minutes = m;
    _seconds = s;
    notifyListeners();
  }

  void setLabel(String l) {
    _label = l;
    notifyListeners();
  }

  void setSound(String s) {
    _sound = s;
    notifyListeners();
  }

  void loadFromRecent(TimerModel model) {
    _hours = model.duration.inHours;
    _minutes = model.duration.inMinutes % 60;
    _seconds = model.duration.inSeconds % 60;
    _remainingSeconds = 0;
    _label = model.label;
    _sound = model.sound;
    _status = TimerStatus.idle;
    notifyListeners();
  }

  void start() {
    int total;
    if (_status == TimerStatus.paused && _remainingSeconds > 0) {
      // Resume from paused state
      total = _remainingSeconds;
    } else {
      // Fresh start
      total = _hours * 3600 + _minutes * 60 + _seconds;
      if (total <= 0) return;
      _remainingSeconds = total;
    }

    _status = TimerStatus.running;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _hours = _remainingSeconds ~/ 3600;
        _minutes = (_remainingSeconds % 3600) ~/ 60;
        _seconds = _remainingSeconds % 60;
        notifyListeners();
      } else {
        _status = TimerStatus.completed;
        _timer?.cancel();
        _addToRecents();
        notifyListeners();
      }
    });
  }

  void pause() {
    if (_status != TimerStatus.running) return;
    _timer?.cancel();
    _status = TimerStatus.paused;
    notifyListeners();
  }

  void resume() {
    if (_status != TimerStatus.paused) return;
    start();
  }

  void cancel() {
    _timer?.cancel();
    _remainingSeconds = 0;
    _hours = 0;
    _minutes = 5;
    _seconds = 0;
    _status = TimerStatus.idle;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _hours = 0;
    _minutes = 5;
    _seconds = 0;
    _status = TimerStatus.idle;
    notifyListeners();
  }

  void dismissCompleted() {
    _status = TimerStatus.idle;
    notifyListeners();
  }

  void _addToRecents() {
    final model = TimerModel(
      duration: wheelDuration,
      label: _label,
      sound: _sound,
    );
    // Avoid duplicates
    _recents.removeWhere((r) => r.label == _label && r.duration == model.duration);
    _recents.insert(0, model);
    if (_recents.length > 5) {
      _recents.removeLast();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
