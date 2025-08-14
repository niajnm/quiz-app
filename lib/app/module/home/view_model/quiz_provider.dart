import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quiz/app/module/home/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class QuizProvider with ChangeNotifier {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedAnswer;

  List<Map<String, dynamic>> _leaderboard = [];

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  bool get answered => _answered;
  int? get selectedAnswer => _selectedAnswer;
  List<Map<String, dynamic>> get leaderboard => _leaderboard;

  Future<void> loadQuestions() async {
    final data = await rootBundle.loadString('assets/questions.json');
    final jsonData = json.decode(data) as List;
    _questions = jsonData.map((q) => Question.fromJson(q)).toList();
    notifyListeners();
  }

  void selectAnswer(int index) {
    if (_answered) return;
    _selectedAnswer = index;
    _answered = true;
    if (_questions[_currentIndex].answerIndex == index) _score++;
    notifyListeners();
  }

  void nextQuestion(BuildContext context) {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _answered = false;
      _selectedAnswer = null;
    } else {
      // Quiz finished: navigate to ResultScreen
      Navigator.pushReplacementNamed(context, '/result');
    }
    notifyListeners();
  }

  Future<void> saveScore(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _leaderboard =
        prefs
            .getStringList('leaderboard')
            ?.map((e) => json.decode(e) as Map<String, dynamic>)
            .toList() ??
        [];
    _leaderboard.add({"name": name, "score": _score});
    _leaderboard.sort((a, b) => b["score"].compareTo(a["score"]));
    await prefs.setStringList(
      'leaderboard',
      _leaderboard.map((e) => json.encode(e)).toList(),
    );
  }

  Future<void> loadLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    _leaderboard =
        prefs
            .getStringList('leaderboard')
            ?.map((e) => json.decode(e) as Map<String, dynamic>)
            .toList() ??
        [];
    notifyListeners();
  }

  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
    _answered = false;
    _selectedAnswer = null;
    notifyListeners();
  }
}
