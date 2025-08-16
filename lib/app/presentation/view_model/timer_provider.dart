import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  static const int questionTime = 15;

  Timer? _timer;
  int _timeLeft = questionTime;
  AnimationController? animationController;

  // Add callback for time expiry
  VoidCallback? _onTimeExpired;

  int get timeLeft => _timeLeft;

  /// Initialize the AnimationController from State
  void initAnimationController(AnimationController controller) {
    animationController = controller;
  }

  /// Set callback for when time expires
  void setTimeExpiredCallback(VoidCallback callback) {
    _onTimeExpired = callback;
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
        // Trigger the time expired callback
        _onTimeExpired?.call();
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
