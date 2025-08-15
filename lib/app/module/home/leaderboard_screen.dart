import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/app/module/home/view_model/quiz_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboard = Provider.of<QuizProvider>(context).leaderboard;

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: ListView.builder(
        itemCount: leaderboard.length,
        itemBuilder: (context, index) {
          final entry = leaderboard[index];
          return ListTile(
            leading: Text('#${index + 1}'),
            title: Text(entry['name']),
            trailing: Text(entry['score'].toString()),
          );
        },
      ),
    );
  }
}
