abstract class ScoreLocalSource {
  Future<void> saveScore(String name, int score);
  Future<List<Map<String, dynamic>>> loadLeaderboard();
}
