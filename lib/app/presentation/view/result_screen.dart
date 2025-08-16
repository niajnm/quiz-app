import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/app/presentation/view_model/quiz_provider.dart';
import 'package:quiz/app/route/route_paths.dart';
import 'package:quiz/app/presentation/components/score_badge.dart';

class ResultScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizPvd = Provider.of<QuizProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Your Result')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            ScoreBadge(score: quizPvd.score, total: quizPvd.questions.length),
            const SizedBox(height: 30),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  await quizPvd.saveScore(name);
                  await quizPvd.loadLeaderboard();
                  Navigator.pushReplacementNamed(
                    context,
                    RoutePaths.leaderboard,
                  );
                }
              },
              child: const Text('Save Score'),
            ),
          ],
        ),
      ),
    );
  }
}
