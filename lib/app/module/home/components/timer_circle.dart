// components/timer_circle.dart
import 'package:flutter/material.dart';

class TimerCircle extends StatelessWidget {
  final double progress;
  final int timeLeft;

  const TimerCircle({
    super.key,
    required this.progress,
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              timeLeft <= 5 ? Colors.red : Colors.blue,
            ),
            strokeWidth: 4,
          ),
        ),
        Text(
          '$timeLeft',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: timeLeft <= 5 ? Colors.red : Colors.blue,
          ),
        ),
      ],
    );
  }
}
