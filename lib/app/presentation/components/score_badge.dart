import 'package:flutter/material.dart';

class ScoreBadge extends StatelessWidget {
  final int score;
  final int total;

  const ScoreBadge({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.blue[700],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your Score',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  '$score/$total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Congratulation',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          'Great job, You Did It!',
          style: TextStyle(fontSize: 16, color: Colors.blue),
        ),
      ],
    );
  }
}
