import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/app/presentation/view_model/quiz_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboard = context.watch<QuizProvider>().leaderboard;

    return Scaffold(
      appBar: AppBar(title: const Text('🏆 Leaderboard'), centerTitle: true),
      body: leaderboard.isEmpty
          ? const Center(child: Text("No scores yet"))
          : ListView.builder(
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                final entry = leaderboard[index];
                final position = index + 1;
                final badge = _getBadge(position);

                return Card(
                  elevation: position <= 3 ? 4 : 1,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: badge.color,
                      child: Icon(badge.icon, color: Colors.white, size: 20),
                    ),
                    title: Text(
                      entry['name'],
                      style: TextStyle(
                        fontWeight: position <= 3
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Text(
                      entry['score'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: badge.color,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  _Badge _getBadge(int position) {
    switch (position) {
      case 1:
        return _Badge(Colors.amber, Icons.emoji_events);
      case 2:
        return _Badge(Colors.grey, Icons.emoji_events);
      case 3:
        return _Badge(Colors.brown, Icons.emoji_events);
      default:
        return _Badge(Colors.blueGrey, Icons.person);
    }
  }
}

class _Badge {
  final Color color;
  final IconData icon;
  _Badge(this.color, this.icon);
}
