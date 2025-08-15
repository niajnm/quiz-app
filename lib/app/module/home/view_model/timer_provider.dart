import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  static const int questionTime = 15;

  Timer? _timer;
  int _timeLeft = questionTime;

  AnimationController? animationController;

  int get timeLeft => _timeLeft;

  /// Add this method to initialize the AnimationController from State
  void initAnimationController(AnimationController controller) {
    animationController = controller;
  }

  void startTimer() {
    _timeLeft = questionTime;
    animationController?.reset();
    animationController?.forward();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeLeft--;
      notifyListeners();
      if (_timeLeft <= 0) {
        timer.cancel();
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    animationController?.stop();
    notifyListeners();
  }

  void disposeTimer() {
    _timer?.cancel();
    animationController?.dispose();
  }
}
