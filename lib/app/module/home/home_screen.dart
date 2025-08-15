import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/app/module/home/view_model/quiz_provider.dart';
import 'quiz_screen.dart';
import 'leaderboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.read<QuizProvider>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 231, 115, 21),
              Color.fromARGB(255, 70, 71, 71),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.quiz, size: 80, color: Colors.blueAccent),
                    const SizedBox(height: 20),
                    const Text(
                      'Flutter Quiz App',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildMenuButton(
                      context,
                      icon: Icons.play_arrow,
                      text: 'Start Quiz',
                      color: Colors.green,
                      onPressed: () async {
                        await quizProvider.loadQuestions();
                        quizProvider.resetQuiz();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const QuizScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildMenuButton(
                      context,
                      icon: Icons.leaderboard,
                      text: 'Leaderboard',
                      color: Colors.orange,
                      onPressed: () async {
                        await quizProvider.loadLeaderboard();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LeaderboardScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 5,
        ),
        icon: Icon(icon, size: 24),
        label: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
