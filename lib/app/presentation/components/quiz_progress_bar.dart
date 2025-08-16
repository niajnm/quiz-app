// components/quiz_progress_bar.dart
import 'package:flutter/material.dart';

class QuizProgressBar extends StatelessWidget {
  final double progress;
  final bool isTimeLow;

  const QuizProgressBar({
    super.key,
    required this.progress,
    required this.isTimeLow,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.grey.shade300,
      valueColor: AlwaysStoppedAnimation<Color>(
        isTimeLow ? Colors.red : Colors.blue,
      ),
      minHeight: 6,
    );
  }
}
