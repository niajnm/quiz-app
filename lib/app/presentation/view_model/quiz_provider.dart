import 'package:flutter/material.dart';
import 'package:quiz/app/data/local/preference/score_local_source.dart';
import 'package:quiz/app/data/repository/questions_repository_source.dart';
import 'package:quiz/app/domain/model/question_model.dart';
import 'package:quiz/app/route/route_paths.dart';
import 'package:quiz/app/core/services/service_locator.dart';

class QuizProvider with ChangeNotifier {
  final QuestionRepositorySource _questionSource =
      serviceLocator<QuestionRepositorySource>();

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
    final data = await _questionSource.fetchQuestionsGet(0);
    _questions = data;
    notifyListeners();
  }

  // void selectAnswer(int index) {
  //   if (_answered) return;
  //   _selectedAnswer = index;
  //   _answered = true;

  //   // Handle timer expiry (index -1) or valid answer
  //   if (index >= 0 && _questions[_currentIndex].answerIndex == index) {
  //     _score++;
  //   }

  //   notifyListeners();
  // }
  void selectAnswer(int index) {
    if (_answered) return;

    _selectedAnswer = index;
    _answered = true;

    // Handle timer expiry (index -1) or valid answer
    // Only increment score if it's a valid answer selection and correct
    if (index >= 0 && index < _questions[_currentIndex].options.length) {
      if (_questions[_currentIndex].answerIndex == index) {
        _score++;
      }
    }
    // If index is -1 (time expired), no score increment (counts as wrong)

    notifyListeners();
  }

  void nextQuestion(BuildContext context) {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _answered = false;
      _selectedAnswer = null;
    } else {
      Navigator.pushReplacementNamed(context, RoutePaths.result);
    }
    notifyListeners();
  }

  final ScoreLocalSource _scoreSource = serviceLocator<ScoreLocalSource>();
  Future<void> saveScore(String name) async {
    await _scoreSource.saveScore(name, _score);
  }

  Future<void> loadLeaderboard() async {
    _leaderboard = await _scoreSource.loadLeaderboard();
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
