import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/app/module/home/view_model/quiz_provider.dart';
import '../providers/quiz_provider.dart';
import 'leaderboard_screen.dart';

class ResultScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final quiz = Provider.of<QuizProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Your Result')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Your Score: ${quiz.score}', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  await quiz.saveScore(name);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LeaderboardScreen()),
                  );
                }
              },
              child: Text('Save Score'),
            ),
          ],
        ),
      ),
    );
  }
}
