import 'package:flutter/material.dart';
import 'package:quiz/app/presentation/components/quiz_progress_bar.dart';
import 'package:quiz/app/presentation/components/timer_circle.dart';

class QuizHeader extends StatelessWidget {
  final int current;
  final int total;
  final double progress;
  final int timeLeft;

  const QuizHeader({
    super.key,
    required this.current,
    required this.total,
    required this.progress,
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Question $current/$total'),
            TimerCircle(progress: progress, timeLeft: timeLeft),
          ],
        ),
        const SizedBox(height: 8),
        QuizProgressBar(progress: progress, isTimeLow: timeLeft <= 5),
      ],
    );
  }
}
