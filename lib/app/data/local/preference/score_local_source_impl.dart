import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'score_local_source.dart';

class ScoreLocalSourceImpl implements ScoreLocalSource {
  static const String leaderboardKey = 'leaderboard';

  final SharedPreferences _prefs;

  ScoreLocalSourceImpl(this._prefs);

  @override
  Future<void> saveScore(String name, int score) async {
    List<Map<String, dynamic>> leaderboard =
        _prefs
            .getStringList(leaderboardKey)
            ?.map((e) => json.decode(e) as Map<String, dynamic>)
            .toList() ??
        [];

    leaderboard.add({"name": name, "score": score});
    leaderboard.sort((a, b) => b["score"].compareTo(a["score"]));

    await _prefs.setStringList(
      leaderboardKey,
      leaderboard.map((e) => json.encode(e)).toList(),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> loadLeaderboard() async {
    return _prefs
            .getStringList(leaderboardKey)
            ?.map((e) => json.decode(e) as Map<String, dynamic>)
            .toList() ??
        [];
  }
}
